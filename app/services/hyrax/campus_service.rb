module Hyrax

  # Provides essential methods for getting the normalized campus name
  #
  module CampusService

    # Extract campus name from a form
    #
    # @param controller [ApplicationController] the current controller
    # @param form [Hyrax::Forms::WorkForm]      the current work form
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

    # Extract campus name from Admin set
    #
    # @param admin_set_name [String] the admin sets public name
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
