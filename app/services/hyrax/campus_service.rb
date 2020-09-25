module Hyrax

  # Provides essential methods for getting the normalized campus name
  #
  module CampusService

    #
    # @return [Hash] short name to campus name map
    #
    def self.campuses
      { bakersfield: 'Bakersfield',
        chancellor: 'Chancellor',
        channel: 'Channel Islands',
        chico: 'Chico',
        dominguez: 'Dominguez Hills',
        eastbay: 'East Bay',
        fresno: 'Fresno',
        fullerton: 'Fullerton',
        humboldt: 'Humboldt',
        longbeach: 'Long Beach',
        losangeles: 'Los Angeles',
        maritime: 'Maritime',
        monterey: 'Monterey Bay',
        mosslanding: 'Moss Landing',
        northridge: 'Northridge',
        pomona: 'Pomona',
        sacramento: 'Sacramento',
        sanbernardino: 'San Bernardino',
        sandiego: 'San Diego',
        sanfrancisco: 'San Francisco',
        sanjose: 'San Jose',
        slo: 'San Luis Obispo',
        sanmarcos: 'San Marcos',
        sonoma: 'Sonoma',
        stanislaus: 'Stanislaus' }
    end

    #
    # Get campus name from short code
    #
    # @param [String] campus_id short campus code, e.g., 'losangeles'
    #
    # @return [String] the campus name, e.g., 'Los Angeles'
    #
    def self.get_campus_name_from_id(campus_id)
      key = campus_id.to_sym
      raise 'Could not find campus name for id: ' + id unless campuses.key?(key)

      campuses[key]
    end

    #
    # Extract campus name from a form
    #
    # @param controller [ApplicationController] the current controller
    # @param form [Hyrax::Forms::WorkForm]      the current work form
    #
    # @return [String] the campus name
    #
    def self.get_campus_from_form(controller, form)
      # if the record has a campus already, take that
      # because we are editing an existing record
      campus = form[:campus].first.to_s.dup
      return campus unless campus.empty?

      # otherwise get it from the admin set name
      # because we are creating a new record
      adminset = Hyrax::AdminSetService.new(controller).search_results(:deposit)
      campus = adminset.first.title_or_label.to_s
      get_campus_from_admin_set(campus)
    end

    #
    # Extract campus name from Admin set
    #
    # @param admin_set_name [String] the admin sets public name
    #
    # @return [String] the campus name
    #
    def self.get_campus_from_admin_set(admin_set_name)
      campuses = ['Bakersfield', 'Chancellor', 'Channel Islands', 'Chico',
                  'Dominguez Hills', 'East Bay', 'Fresno', 'Fullerton',
                  'Humboldt', 'Long Beach', 'Los Angeles', 'Maritime',
                  'Monterey Bay', 'Moss Landing', 'Northridge', 'Pomona',
                  'Sacramento', 'San Bernardino', 'San Diego',
                  'San Francisco', 'San Jose', 'San Luis Obispo',
                  'San Marcos', 'Sonoma', 'Stanislaus']

      campuses.each do |campus|
        return campus.to_s if admin_set_name.to_s.include?(campus.to_s)
      end

      raise 'No campus admin set found'
    end
  end
end
