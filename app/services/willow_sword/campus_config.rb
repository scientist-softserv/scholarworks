#
# Collection visibility configurations
#
module WillowSword
  class CampusConfig
    #
    # New collection visibility config
    #
    # @param collection [String]  collection id
    #
    def initialize(collection)
      @collection = collection
      path = Rails.root.join('config', 'sword.yml')
      file = YAML.safe_load(File.read(path))

      unless file.key?(collection)
        raise 'Could not find configuration for ' + collection
      end

      @config = file[collection]
    end

    def default_type
      get_config('default_type', 'Masters Thesis')
    end

    def visibility
      get_config('visibility', 'open')
    end

    def visibility_during_embargo
      get_config('visibility_during_embargo', 'restricted')
    end

    def visibility_after_embargo
      get_config('visibility_after_embargo', 'open')
    end

    private

    #
    # Get config value, if present
    #
    # @param name [String]  config name
    # @param default [String] default value
    #
    # @return [String]
    #
    def get_config(name, default)
      if @config.key?(name)
        @config[name]
      else
        default
      end
    end
  end
end
