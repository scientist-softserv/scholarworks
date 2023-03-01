WillowSword.setup do |config|
  # The title used by the sword server, in the service document
  config.title = 'Hyrax Sword V2 server'
  # If you do not want to use collections in Sword, it will use this as a default collection
  config.default_collection = { id: 'default', title: ['Default collection'] }
  # The name of the model for retrieving collections (based on Hyrax integration)
  config.collection_models = ['Collection']
  # The work models supported by Sword (based on Hyrax integration)
  config.work_models = ['Thesis']
  # The fileset model supported by Sword (based on Hyrax integration)
  config.file_set_models = ['FileSet']
  # Remove all parameters that are not part of the model's permitted attributes
  config.allow_only_permitted_attributes = false
  # Default visibility for works
  # config.default_visibility = 'open'
  # Metadata filename in payload
  config.metadata_filename = 'mets.xml'
  # XML crosswalk for creating a work
  config.xw_from_xml_for_work = WillowSword::CrosswalkFromDspace
  # XML crosswalk for creating a fileset
  config.xw_from_xml_for_fileset = WillowSword::CrosswalkFromDspace
  # XML crosswalk when requesting a work
  config.xw_to_xml_for_work = WillowSword::CrosswalkWorkToDc
  # XML crosswalk when requesting a fileset
  config.xw_to_xml_for_fileset = WillowSword::CrosswalkFilesetToDc
  # Authorize Sword requests using Api-key header
  config.authorize_request = false
  # Customize attribute transformation
  config.before_work_transform_attributes = lambda { |params, attributes, tmp_dir|

    # admin set
    if params['admin_set_id'].present?
      attributes['admin_set_id'] = params['admin_set_id']
    end

    config = WillowSword::CampusConfig.new(params['collection_id'])

    # visibility
    if attributes.key?('embargo_release_date')
      attributes['visibility'] = 'embargo'
      attributes['visibility_during_embargo'] = config.visibility_during_embargo
      attributes['visibility_after_embargo'] = config.visibility_after_embargo
    else
      attributes['visibility'] = config.visibility
    end

    # default resource type
    unless attributes['resource_type'].present?
      attributes['resource_type'] = [config.default_type]
    end

    # original sword package for reference
    sword_package = tmp_dir.split('/').pop
    attributes['provenance'] = ['sword:' + sword_package]
  }
end
