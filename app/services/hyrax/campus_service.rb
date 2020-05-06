module Hyrax
  module CampusService

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

    def self.get_campus_name_from_id(campus_id)
      key = campus_id.to_sym
      raise 'Could not find campus name for id: ' + id unless campuses.key?(key)

      campuses[key]
    end

    def self.get_campus_from_admin_set(admin_set_name)
      campuses.values.each do |campus|
        return campus.to_s if admin_set_name.to_s.include?(campus.to_s)
      end
      raise 'No campus admin set could be found'
    end
  end
end
