# frozen_string_literal: true

require 'calstate/metadata'
require 'colorize'
require 'time'
require 'yaml'
require 'zip'

module CalState
  module Packager
    #
    # Packager
    #
    class AbstractPackager
      #
      # Metadata only
      #
      # @return [Boolean]
      #
      attr_accessor :metadata_only

      #
      # New packager
      #
      # @param admin_set [String]  admin set ID
      # @param campus [String]     campus slug
      # @param depositor [String]  depositor
      #
      def initialize(admin_set, campus, depositor)
        @campus_slug = campus
        @admin_set = admin_set
        @depositor = depositor

        @campus = CampusService.get_name_from_slug(@campus_slug)
        @fix_params = false
        @metadata_only = false
        @exit_on_error = false

        @throttle = 0
        @throttle_on_error = 60
        @log = Packager::Log.new
        @errors = 0
        @type_map = CalState::Metadata.model_type_map
        @admin_set_check = []

        # campus config
        config_file = "config/packager/#{campus}.yml"
        @config = OpenStruct.new(YAML.ext_load_file(config_file))

        @input_dir = @config['input_dir'] ||= '/data/import'
        @default_model = @config['default_model']
        @metadata_only = true if @config['metadata_only'] == 'true'
        @exit_on_error = true if @config['exit_on_error'] == 'true'
      end

      #
      # Set throttle
      #
      # @param value [Integer]
      #
      def throttle=(value)
        @throttle = value.to_i
      end

      protected

      #
      # Process an item
      #
      # @param params [Hash]  record attributes
      # @param files [Array]  file locations
      # @param args           other args to pass to error handling
      #
      def process_item(params, files, **args)
        begin
          start_time = DateTime.now
          on_create(params, files, **args)

          # record the time it took
          end_time = Time.now.minus_with_coercion(start_time)
          total_time = Time.at(end_time.to_i.abs).utc.strftime('%H:%M:%S')
          @log.info "Total time: #{total_time}"
          @log.info 'DONE!'.green

        rescue Net::ReadTimeout => e
          process_error(e, params, files, **args)
          sleep @throttle_on_error

        rescue ActiveFedora::UnknownAttributeError => e
          process_error(e, params, files, **args)
          @errors -= 1 # keep on truckin'

        rescue StandardError => e
          process_error(e, params, files, **args)
          sleep @throttle_on_error

        else
          @errors = 0 # success, so reset the counter
          on_success(params, files, **args)
        end

        @log.info "\n\n"
        sleep @throttle unless @throttle.zero?
      end

      #
      # Log error and optionally exit
      #
      # @param error [StandardError]  the error
      # @param params [Hash]          record attributes
      # @param files [Array]          file locations
      # @param args                   other args to pass to error processing
      #
      def process_error(error, params, files, **args)
        @log.error error.class.to_s.red
        @log.error error
        @errors += 1

        # save unprocessed record for retry
        on_error(error, params, files, **args)

        # exit if so configured or we got three errors in a row
        raise error if @exit_on_error || @errors >= 3
      end

      #
      # Tasks to perform when processing item
      #
      # @param params [Hash]  record attributes
      # @param files [Array]  file locations
      # @param args           other args to pass to error processing
      #
      def on_create(params, files, **args)
        create_work(params, files)
      end

      #
      # What to do on success
      #
      # @param params [Hash]  record attributes
      # @param files [Array]  file locations
      # @param args           other args to pass to error processing
      #
      def on_success(params, files, **args); end

      #
      # What to do on error
      #
      # @param error [StandardError]  the error
      # @param params [Hash]          record attributes
      # @param files [Array]          file locations
      # @param args                   other args to pass to error processing
      #
      def on_error(error, params, files, **args); end

      #
      # Create work and attach any files
      #
      # @param params [Hash]  record attributes
      # @param files [Array]  [optional] file locations
      #
      def create_work(params, files = [])
        work = create_new_work(params)
        params['id'] = work.id
        attach_files(work, files) unless files.empty?

        unless params['collection'].blank?
          @log.info "Adding work (#{id}) to collections (#{params['collection'].join(', ')})"
          Packager.add_to_collection(work, params['collection'])
        end

        @log.info 'Adding manager group to work.'
        work = Packager.add_manager_group(work, @campus_slug)
        work.save

        @log.info 'Adding manager group to files.'
        work.file_sets.each do |file_set|
          Packager.add_manager_group(file_set, @campus_slug)
          file_set.save
        end

        @log.info 'Registering work with Handle service.'
        HandleRegisterJob.perform_now(work)
      end

      #
      # Create or update work
      #
      # @param params [Hash]         record params
      # @param match_field [String]  field to look-up existing work on
      # @param match_value [String]  value to look-up existing work on
      #
      def create_or_update_work(params, match_field, match_value)
        works = find_work(match_field, match_value)

        if works.empty?
          @log.info "Creating a new work for: #{match_value}"
          create_work(params, [])
        else
          work = works.first
          @log.info "Updating existing work (#{work.id}) for: " + match_value
          update_work(work, params)
        end
      end

      #
      # Delete work
      #
      # @param match_field [String]  field to look-up existing work on
      # @param match_value [String]  value to look-up existing work on
      #
      def delete_work(match_field, match_value)
        works = find_work(match_field, match_value)
        return if works.blank?

        work = works.first
        @log.info "Deleting existing work (#{work.id}) for: " + match_value
        work.destroy!
      end

      #
      # Update work
      #
      # @param work [ActiveFedora::Base]
      # @param params [Hash]             record attributes
      #
      def update_work(work, params)
        params = value_map(params)
        work.update(params)
      rescue ActiveFedora::UnknownAttributeError => e
        raise e unless @fix_params

        @log.warn e.message
        params = fix_params(work, params)
        work.update(params)
      end

      #
      # Convert values using value_map from config
      #
      # @param params [Hash]  record attributes
      #
      # @return [Hash]
      #
      def value_map(params)
        @config['value_map']&.each do |field, value_map|
          next unless params[field]

          if params[field].is_a?(Array)
            final = []
            params[field].each do |value|
              final.append value_map[value] if value_map.key?(value)
            end
            params[field] = final
          elsif value_map.key?(params[field])
            params[field] = value_map[params[field]]
          end
        end

        params
      end

      #
      # Update visibility on work and files
      #
      # @param work [ActiveFedora::Base]   Fedora work
      # @param work_visibility [String]    visibility for work
      # @param file_visibility [String]    [optional] visibility for file
      #
      # @return [FalseClass]
      #
      def update_visibility(work, work_visibility, file_visibility = nil?)
        # this is ugly, but couldn't find a more efficient way to do this,
        # especially for campus visibility which behaves differently

        if work_visibility != file_visibility && file_visibility.present?
          # set work to file visibility so files can inherit from that
          work.visibility = file_visibility
          work.save
          VisibilityCopyJob.perform_now(work)

          # then set work to work visibility
          work.visibility = work_visibility
          work.save
        else
          work.visibility = work_visibility
          work.save
          VisibilityCopyJob.perform_now(work)
        end
      end

      #
      # Upload and attach files to Hyrax
      #
      # @param work [ActiveFedora::Base]  work
      # @param files [Array<String>]              file locations
      #
      def attach_files(work, files)
        @log.info 'Attaching files.'

        uploaded_files = []

        if files.empty?
          @log.info 'No files to attach.'
          raise MetadataError, 'No files to attach!' unless @metadata_only

          return false
        end

        files.each do |file|
          next if file.blank?

          uploaded_file = if file.is_a? Hyrax::UploadedFile
                            file
                          else
                            file_obj = File.open(file)
                            Hyrax::UploadedFile.create(file: file_obj)
                          end
          uploaded_file.save
          uploaded_files.append uploaded_file
        end

        @log.info 'Attaching file(s) to work job.'
        AttachFilesToWorkJob.perform_now(work, uploaded_files)
      end

      #
      # Remove all file_sets from a work
      #
      # @param work [ActiveFedora::Base]
      #
      def remove_files(work)
        work.file_sets.each(&:destroy!)
      end

      #
      # Transform source XML to simple field XML
      #
      # @param xml [Nokogiri::XML::Document]  source XML document
      # @param xslt_file [String]             xslt file name
      #
      # @return [Nokogiri::XML::Document]
      #
      def transform_xml(xml, xslt_file)
        xslt = Nokogiri::XSLT(File.read(xslt_file))
        xslt.transform(xml)
      end

      #
      # Format date as YYYY-MM-DD, if possible
      #
      # @param date [String]
      #
      # @return [String]
      #
      def format_date(date)
        return date if date.blank?

        if date.length < 7 && /\d/.match(date)
          date_parsed = nil
          date_parsed = date[0..3] if date.length > 3
          date_parsed += "-#{date[4..5]}" if date.length == 6
          date_parsed
        else
          Date.parse(date, '%Y-%m-%d').to_s
        end
      rescue ArgumentError
        date
      end

      #
      # Format dates as YYYY-MM-DD, if possible
      #
      # @param dates [Array]
      #
      # @return [Array]
      #
      def format_dates(dates)
        final = []
        dates.each do |date|
          final.append format_date(date)
        end

        final
      end

      #
      # Create a directory
      # only if it doesn't already exist
      #
      # @param dir [String]
      #
      # @return [String] the new directory
      #
      def initialize_directory(dir)
        Dir.mkdir(dir) unless Dir.exist?(dir)
        dir
      end

      private

      #
      # Find a work
      #
      # @param match_field [String]  field to look-up existing work on
      # @param match_value [String]  value to look-up existing work on
      #
      def find_work(match_field, match_value)
        query = { Solrizer.solr_name(match_field) => match_value }
        ActiveFedora::Base.where(query)
      end

      #
      # Only return the parameters that are part of the model
      #
      # @param work [ActiveFedora::Base]
      # @param params [Hash]
      #
      # @return [Hash]
      #
      def fix_params(work, params)
        final = {}
        params.each do |field, value|
          if work.attribute_names.include?(field) || FieldService.visibility_fields.include?(field)
            final[field] = value
          else
            @log.warn "Removing `#{field}`, not part of " + work.class.name
          end
        end

        final
      end

      #
      # Get model from supplied resource type
      #
      # @param resource_types [Array]
      #
      # @return [String]
      #
      def get_model_from_type(resource_types)
        resource_type = resource_types.first

        if @type_map.key?(resource_type)
          @type_map[resource_type]
        elsif @default_model.present?
          @default_model
        else
          raise MetadataError, "Could not find model for: #{resource_type}"
        end
      end

      #
      # Create a new Hyrax work
      #
      # @param params [Hash]  record attributes
      #
      # @return [ActiveFedora::Base] the work
      #
      def create_new_work(params)
        @log.info 'Creating new work.'

        # admin set
        params['admin_set_id'] = @admin_set

        # depositor
        depositor = User.find_by_user_key(@depositor)
        raise MetadataError, "User #{@depositor} not found." if depositor.nil?

        begin
          params = ensure_required_metadata(params)
        ensure
          @log.info params.inspect
        end

        # get model
        model = if params['model'].blank?
                  get_model_from_type(params['resource_type'])
                else
                  params['model']
                end

        id = Noid::Rails::Service.new.minter.mint

        @log.info "Creating a new #{model} with id: #{id}"
        @log.info "Title: #{params['title'].first}"

        object = Kernel.const_get(model)
        work = object.new(id: id)
        work.apply_depositor_metadata(depositor.user_key)
        update_work(work, params.except('model', 'collection', 'id'))

        work
      end

      #
      # Ensure we have the needed metadata for a work
      #
      # @param record_params [Hash]
      #
      # @return [Hash]
      #
      def ensure_required_metadata(record_params)
        params = {}

        # remove empty params and ensure multi-valued ones are actually multi-valued
        record_params.each do |field, value|
          value = [value] if !value.is_a?(Array) && !FieldService.single_fields.include?(field)
          params[field] = value unless value.blank?
        end

        # title
        raise MetadataError, 'No title set in params.' if params['title'].blank?

        # admin set
        if params['admin_set_id'].blank? && @config['admin_set_id']
          params['admin_set_id'] = @config['admin_set_id']
        end

        if params['admin_set_id'].blank?
          raise MetadataError, 'No admin_set_id supplied in params.'
        end

        unless @admin_set_check.include?(params['admin_set_id'])
          AdminSet.find(params['admin_set_id'])
          @admin_set_check.append(params['admin_set_id'])
        end

        # campus
        params['campus'] = [@campus] if params['campus'].blank? && @campus
        raise MetadataError, 'No campus supplied in params.' if params['campus'].blank?

        params['campus'].each do |campus|
          CampusService.ensure_campus_name(campus)
        end

        # resource type
        if params['resource_type'].blank?
          if @config['default_type'].blank?
            raise MetadataError, 'No resource_type supplied in params'
          else
            params['resource_type'] = [@config['default_type']]
          end
        end

        # visibility
        if params['visibility'].blank?
          params['visibility'] = @config['visibility']
          params['visibility'] = 'open' if params['visibility'].blank?
        end

        params
      end
    end
  end
end
