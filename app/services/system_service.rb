# frozen_string_literal: true

#
# Search Configuration
#
class SystemService
  #
  # Facet fields
  #
  # @return [Hash]
  #
  def self.facets
    config['facets']
  end

  #
  # Advanced search fields
  #
  # @return [Array] string
  #
  def self.advanced_search
    config['advanced_search']
  end

  #
  # Models
  #
  # @return [Array] symbols
  #
  def self.models
    config['models'].map &:to_s
  end

  #
  # archive?
  #
  # @return true if it's an archive system
  #
  def self.archive?
    return models[0] == 'archive'
  end

  #
  # System configuration file
  #
  # @return [Hash]
  #
  def self.config
    return @config unless @config.nil?

    config_file = Rails.root + 'config/system.yml'
    @config = OpenStruct.new(YAML.load_file(config_file))

    @config
  end
end
