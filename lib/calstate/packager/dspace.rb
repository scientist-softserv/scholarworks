# frozen_string_literal: true

module CalState
  module Packager
    #
    # DSpace importer
    #
    class Dspace < AbstractPackager
      #
      # New DSpace packager
      #
      # @param campus [String]  campus slug
      #
      def initialize(campus)
        super(campus)

        @log.info 'Campus: ' + @campus

        # set working directories
        @input_dir = @config['input_dir']
        @output_dir = initialize_directory(File.join(@input_dir, 'unpacked'))
        @complete_dir = initialize_directory(File.join(@input_dir, 'complete'))
        @error_dir = initialize_directory(File.join(@input_dir, 'error'))
      end

      #
      # Process all items
      #
      def process_items
        @log.info 'Processing all items.'

        Dir.foreach(@input_dir) do |filename|
          next unless filename.include?('.zip') && filename.include?('ITEM')

          process_package(filename)
          sleep @throttle unless @throttle.zero?
        end
      end

      #
      # Process the supplied package from the @input directory
      # unzips the package and processes its contents
      # moves processed zip files to 'complete' or 'error' dirs
      #
      # @param source_file [String]  the .zip file to process
      #
      def process_package(source_file)
        @log.info "\n\nProcessing " + source_file

        # unzip package and set file working directory
        zip_file = File.join(@input_dir, source_file)
        file_dir = unzip_package(zip_file)

        # no zip file found, so skip it
        return nil if file_dir.nil?

        # make sure we actually have a mets file
        mets_file = File.join(file_dir, 'mets.xml')
        raise 'No METS file found in ' + file_dir unless File.exist?(mets_file)

        # parse it
        dom = Nokogiri::XML(File.open(mets_file))

        # determine the type of object
        # if this is a dspace item, create a new work
        # otherwise process the items from this community/collection

        type = dom.root.attr('TYPE')

        if ['DSpace COMMUNITY', 'DSpace COLLECTION'].include?(type)
          struct_data = dom.xpath('//mets:mptr', 'mets' => 'http://www.loc.gov/METS/')
          struct_data.each do |file_data|
            if file_data.attr('LOCTYPE') == 'URL'
              process_package(file_data.attr('xlink:href'))
            end
          end
        elsif type == 'DSpace ITEM'
          params = prepare_params(dom)
          files = []
          files = prepare_files(file_dir, dom) unless @metadata_only

          process_item(params, files, zip: source_file)
        end
      end

      #
      # What to do on error
      #
      # @param error [StandardError]  the error
      # @param params [Hash]          record attributes
      # @param files [Array]          file locations
      # @param args                   other args to pass to error processing
      #
      def on_error(error, params, files, **args)
        working_loc = File.join(@input_dir, args[:zip])
        error_loc = File.join(@error_dir, args[:zip])
        File.rename(working_loc, error_loc)
      end

      #
      # What to do on success
      #
      # @param params [Hash]  record attributes
      # @param files [Array]  file locations
      # @param args           other args to pass to error processing
      #
      def on_success(params, files, **args)
        working_loc = File.join(@input_dir, args[:zip])
        comp_loc = File.join(@complete_dir, args[:zip])
        File.rename(working_loc, comp_loc)
      end

      #
      # Prepare params
      #
      # @param dom [Nokogiri::XML::Document]  DOMDocument of METS file
      #
      # @return [Hash]  params
      #
      def prepare_params(dom)
        @log.info 'Mapping fields'

        params = {}

        # extract values from the mets xml
        doc = transform_xml(dom, xslt_file)
        doc.xpath('//record').each do |record|
          params = FieldService.xml_to_params(record)
        end

        # set defaults
        params['campus'] = [@campus]
        params['admin_set_id'] = @config['admin_set_id']

        # set visibility
        if params.key?('embargo_release_date')
          # indefinite embargo, just make it private
          if params['embargo_release_date'].include?('10000-01-01') ||
             params['embargo_release_date'].empty?
            params['visibility'] = 'restricted'
            params.except!('embargo_release_date')
          else # regular embargo
            params['visibility_after_embargo'] = 'open'
            params['visibility_during_embargo'] = 'authenticated'
          end
        else
          params['visibility'] = 'open'
        end

        params
      end

      #
      # Prepare files
      #
      # @param file_dir [String]              the file working directory
      # @param dom [Nokogiri::XML::Document]  DOMDocument of METS file
      #
      # @return [Array]  files
      #
      def prepare_files(file_dir, dom)
        @log.info 'Figuring out which files to upload'

        uploaded_files = []

        # xpath variables
        premis_ns = { 'premis' => 'http://www.loc.gov/standards/premis' }
        mets_ns = { 'mets' => 'http://www.loc.gov/METS/' }
        original_name_xpath = 'premis:originalName'

        # loop over the files listed in the METS
        file_md5_list = dom.xpath('//premis:object', premis_ns)
        file_md5_list.each do |fptr|
          # file location info
          file_id = fptr.parent.parent.parent.parent.parent.attr('ID')
          next if file_id.nil?

          flocat_xpath = "//mets:file[@ADMID='" + file_id + "']/mets:FLocat"
          file_location = dom.at_xpath(flocat_xpath, mets_ns)

          # the name of the file in the aip package and its original name
          aip_filename = file_location.attr('xlink:href')
          orig_filename = fptr.at_xpath(original_name_xpath, premis_ns).inner_html

          # type of file
          file_type = file_location.parent.parent.attr('USE')

          if file_type == 'ORIGINAL'
            uploaded_file = rename_file(file_dir, orig_filename, aip_filename, 'bitstream')
            uploaded_files.append(uploaded_file) unless uploaded_file.nil?
          end
        end

        uploaded_files
      end

      #
      # Rename file to original name instead of name given by aip package
      #
      # @param file_dir [String]       the file working directory
      # @param orig_filename [String]  the original file name
      # @param aip_filename [String]   the name given by DSpace AIP export
      # @param type [String]           whether 'thumbnail' or 'bitstream'
      #
      # @return [String]  the new file name
      #
      def rename_file(file_dir, orig_filename, aip_filename, type)
        @log.info "Renaming #{type} #{aip_filename} -> #{orig_filename}"

        File.rename(file_dir + '/' + aip_filename,
                    file_dir + '/' + orig_filename)

        file_dir + '/' + orig_filename
      end

      #
      # Extract a .zip file
      # extracted files go to the @output directory
      #
      # @param zip_file [String]  the full path of the zip file
      #
      # @return [String|nil] the full path of the directory created, nil if not found
      #
      def unzip_package(zip_file)
        @log.info 'Unzipping ' + zip_file

        unless File.exist?(zip_file)
          @log.error zip_file + ' not found.'
          return nil
        end

        # create a new directory
        file_dir = File.join(@output_dir, File.basename(zip_file, '.zip'))
        Dir.mkdir file_dir unless Dir.exist?(file_dir)

        # extract contents of zip file
        Zip::File.open(zip_file) do |zipfile|
          zipfile.each do |f|
            fpath = File.join(file_dir, f.name)
            zipfile.extract(f, fpath) unless File.exist?(fpath)
          end
        end

        file_dir
      end

      #
      # Get XSLT file for DSpace to Simple Field XML
      #
      # @return [String]
      #
      def xslt_file
        campus_file = "#{Rails.root}/config/packager/xslt/#{@campus}.xslt"
        return campus_file if File.exist?(campus_file)

        "#{Rails.root}/config/mappings/dspace.xslt"
      end
    end
  end
end
