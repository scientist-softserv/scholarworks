# frozen_string_literal: true

#
# Search Configuration
#
class FileService
  #
  # Extract and assign file type from files to work field for faceting
  #
  # @param work [String]
  #
  def self.add_file_type(work_id)
    # get the work itself since we'll need to update it
    work = ActiveFedora::Base.find(work_id)
    file_type = self.type(work.title.first)

    unless file_type.nil?
      if (work.file_type.empty?)
        work.file_type = [file_type]
      else
        work.file_type = work.file_type + [file_type]
      end
      work.save
    end
  end

  #
  # Get file type
  #
  # @return String or nil
  #s
  def self.type(file_name)
    return nil if file_name.rindex('.').nil?

    extension = file_name[file_name.rindex('.') + 1, file_name.size]
    ret_type = extension.nil? ? '' : types[extension.downcase.to_sym]
    ret_type.nil? ? 'Text' : ret_type
  end

  #
  # File extension type
  #
  # @return [Hash]
  #
  def self.types
    return @types unless @types.nil?

    file_extension_type = Rails.root + 'config/file_types.yml'
    @types = YAML.load_file(file_extension_type).symbolize_keys

    @types
  end
end
