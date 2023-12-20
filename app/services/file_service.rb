# frozen_string_literal: true

#
# Search Configuration
#
class FileService
  #
  # get file type
  #
  # @return String
  #s
  def self.type(file_name)
    extension = file_name[file_name.rindex('.')+1, file_name.size]
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
