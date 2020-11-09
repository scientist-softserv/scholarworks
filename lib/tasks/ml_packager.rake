# frozen_string_literal: true

require 'colorize'
require 'rubygems'
require 'time'
require 'yaml'
require 'zip'

namespace :ml_packager do
  desc 'Migrate Landing moss packages to Hyrax'
  task :ml, %i[campus type visibility] => [:environment] do |_t, args|
    # error check
    campus = args[:campus] or raise 'No campus provided.'
    # source_file = args[:file] or raise 'No zip file provided.'
    @type = args[:type]
    @visibility = args[:visibility] ||= 'open'

    # config and loggers
    config_file = 'config/packager/' + campus + '.yml'
    @config = OpenStruct.new(YAML.load_file(config_file))
    @log = Packager::Log.new(@config['output_level'])
    @handle_report = File.open(@config['handle_report'], 'w')
    @log.info ' Work type ' + @type
    @log.info ' Visibility ' + @visibility

    raise 'Must set metadata_file in the config' unless @config['metadata_file']
    raise 'Must set data_file in the config' unless @config['data_file']
    raise 'Must set campus name in config' unless @config['campus']

    # set working directories
    @input_dir = @config['input_dir']
    @complete_dir = initialize_directory(@input_dir + '_complete')
    @error_dir = initialize_directory(@input_dir + '_error')
    @log.info 'input dir ' + @input_dir
    @log.info 'complete dir ' + @complete_dir
    @log.info 'error_dir ' + @error_dir

    @log.info 'Starting rake task packager:ml'.green
    @log.info 'Campus: ' + @config['campus'].yellow
    @log.info 'Loading import package from ' + @input_dir

    Dir.each_child(@input_dir) do |dirname|
      @log.info 'process ' + dirname
      process_dir(dirname)
    end
  end
end

def cleanup(source_path, dest_path)
  # create directories if needed
  cur_path = ''
  paths = dest_path.split('/')
  paths.each do |dirname|
    next if dirname.nil? || dirname.empty?

    cur_path = cur_path + '/' + dirname
    Dir.mkdir(cur_path) unless Dir.exist?(cur_path)
  end

  # now move files over to new dest directory
  Dir.glob(File.join(@input_dir + '/' + source_path, '*')).each { |f| FileUtils.mv(f, dest_path) }

  # now remove the source dir
  delete_dir = File.join(@input_dir, source_path)
  Dir.delete delete_dir if File.exist?(delete_dir)
end

def process_dir(path)
  return unless File.directory?(File.join(@input_dir, path))

  # process subdirectories
  Dir.each_child(File.join(@input_dir, path)) do |subdir|
    process_dir(path + '/' + subdir)
  end

  sleep(3)
  metadata_file = ''
  valid_metadata = false
  metadata_files = @config['metadata_file'].split('|')
  metadata_files.each do |name|
    metadata_file = File.join(@input_dir + '/' + path, name)
    if File.exist?(metadata_file)
      valid_metadata = true
      break
    end
  end

  done_dir = File.join(@error_dir, path)
  if valid_metadata
    # we still need to check for PDF file
    data_file = nil
    data_files = @config['data_file'].split('|')
    data_files.each do |fileext|
      Dir.glob(@input_dir + '/' + path + '/*.' + fileext) do |filename|
        data_file = filename
        break
      end
      next if data_file.nil?

      begin
        @log.info 'Using metatadata file ' + metadata_file
        @log.info 'Using data file ' + data_file
        process_metadata(path, metadata_file, data_file)
        done_dir = File.join(@complete_dir, path)
      rescue StandardError => e
        @log.error e.class.to_s.red
        @log.error e
      end
      break
    end
  end

  cleanup(path, done_dir)
end

# Process the DC Record file in a directory
# creates new work(s) based on content
#
# @param dirname [String] the directory of the extracted package
# @raise RuntimeError if no METS file found
#
def process_metadata(dir_name, metadata_file, data_file)
  @log.info 'Processing metadata file'
  @log.info 'metadata file ' + metadata_file

  # make sure we actually have a mets file
  raise 'No metadata file found in ' + dir_name unless File.exist?(metadata_file)

  # parse it
  dom = Nokogiri::XML(File.open(metadata_file))

  # determine the type of object
  # if this is a dspace item, create a new work
  # otherwise process the items from this community/collection

  ml_create_work_and_files(dom, data_file)
end

# Create new work and attach any files
#
# @param file_dir [String] the file working directory
# @param dom [Nokogiri::XML::Document] DOMDocument of METS file
#
def ml_create_work_and_files(dom, data_file)
  @log.info 'Ingesting moss landing ' + @type

  start_time = DateTime.now

  # data mapper
  params = ml_collect_params(dom)
  pp params if @debug

  @log.info 'Creating Hyrax work...'
  work = ml_create_new_work(params)

  if @config['metadata_only']
    @log.info 'Metadata only'
  else
    @log.info 'Getting uploaded files'
    uploaded_files = ml_get_files_to_upload(data_file)

    @log.info 'Attaching file(s) to work job...'
    AttachFilesToWorkJob.perform_now(work, uploaded_files)
  end

  # record the time it took
  end_time = Time.now.minus_with_coercion(start_time)
  total_time = Time.at(end_time.to_i.abs).utc.strftime('%H:%M:%S')
  @log.info 'Total time: ' + total_time
  @log.info 'DONE!'.green
end

# Create a new Hyrax work
#
# @param params [Hash] the field/xpath mapper
# @return [ActiveFedora::Base] the work
#
def ml_create_new_work(params)
  @log.info 'Configuring work attributes'

  # set depositor
  depositor = User.find_by_user_key(@config['depositor'])
  raise 'User ' + @config['depositor'] + ' not found.' if depositor.nil?

  # set noid
  id = Noid::Rails::Service.new.minter.mint

  # set resource type
  resource_type = @type || 'Thesis'

  # set visibility
  params['visibility'] = @visibility

  # set admin set to deposit into
  params['admin_set_id'] = @config['admin_set_id'] unless @config['admin_set_id'].nil?

  # set campus
  params['campus'] = [@config['campus']]

  @log.info 'Creating a new ' + resource_type + ' with id:' + id

  raise 'No mapping for ' + resource_type if @config['type_to_work_map'][resource_type].nil?

  model_name = @config['type_to_work_map'][resource_type]

  # create the actual work based on the mapped resource type
  model = Kernel.const_get(model_name)
  work = model.new(id: id)
  work.update(params)
  work.apply_depositor_metadata(depositor.user_key)
  work = add_managers(work, @config['admin_set_id'])
  work.save

  work
end

# Get files to upload
# extracts file info for bitstream (optionally also thumnail) from METS and
# creates UploadedFile objects for each
#
# @param dom [Nokogiri::XML::Document] DOMDocument of METS file
# @return [Array<Hyrax::UploadedFile>]
#
def ml_get_files_to_upload(pdf_file)
  @log.info 'Figuring out which files to upload'

  uploaded_files = []

  uploaded_file = ml_upload_file(pdf_file)
  uploaded_files.push(uploaded_file) unless uploaded_file.nil?

  uploaded_files
end

# Upload file to Hyrax
# uses the original file name instead of name given by aip package
#
# @param file_dir [String] the file working directory
# @param orig_filename [String] the original file name
# @param aip_filename [String] the name given by DSpace AIP export
# @param type [String] whether 'thumbnail' or 'bitstream'
# @retu:1
# :rn Hyrax::UploadedFile
#
def ml_upload_file(filename)
  @log.info 'uploading filename ' + filename

  return unless File.file?(filename)

  @log.info 'Uploading file ' + filename
  file = File.open(filename)

  uploaded_file = Hyrax::UploadedFile.create(file: file)
  uploaded_file.save

  file.close

  uploaded_file
end

def process_creator(data, params)
  ignore_tag = '(translator)'
  creator_tags = {
    '(creator)' => 'creator',
    '(author)' => 'creator',
    '(editor)' => 'editor',
    '(publisher)' => 'publisher',
    '(home campus)' => 'granting_institution',
    '(thesis advisor)' => 'advisor',
    '(thesis committee member)' => 'committee_member' }
  data_lc = data.downcase
  return if data_lc.end_with? ignore_tag

  creator_tags.each do |key, value|
    next unless data_lc.end_with? key

    new_data = data[0, data.length - key.length].strip
    params[value] << new_data unless new_data.empty? || new_data == ','
    return nil
  end

  # default to creator if no ending tag is found
  params['creator'] << data
end

# Extract data from XML based on config data mapping
#
# @param dom [Nokogiri::XML::Document] DOMDocument of METS file
# @return Hash
#
def ml_collect_params(dom)
  desc_metadata_prefix = @config['Thesis']['desc_metadata_prefix']
  namespace = @config['Thesis']['namespace']

  params = Hash.new { |h, k| h[k] = [] }
  @config['fields'].each do |field|
    field_name = field[0]
    field_definition = field[1]
    next unless field_definition.include? 'xpath'

    # definition checks
    raise '"' + field_name + '" defined with empty xpath' if field_definition['xpath'].nil?
    raise '"' + field_name + '" missing type' if field_definition['type'].nil?

    field_definition['xpath'].each do |current_xpath|
      metadata = dom.xpath(desc_metadata_prefix + current_xpath, namespace)
      unless metadata.empty?
        if field_definition['type'].include? 'Array'
          metadata.each do |node|
            node_text = node.text.squish
            # ignore empty data or resource_type of value 'text'
            next if node_text.nil?
            next if node_text.empty?
            next if field_name == 'resource_type' && node_text.casecmp('TEXT').zero?

            if field_name == 'creator'
              process_creator(node_text, params)
            else
              params[field_name] << node_text
            end
          end
        else
          params[field_name] = metadata.text.squish
        end
      end
    end
  end

  params
end

# Create a directory
# only if it doesn't already exist
#
# @param dir [String]
# @return [String] the new directory
#
def initialize_directory(dir)
  Dir.mkdir(dir) unless Dir.exist?(dir)
  dir
end
