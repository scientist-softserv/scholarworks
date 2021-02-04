# frozen_string_literal: true

module Hyrax
  #
  # Provides essential methods for getting the normalized campus name
  #
  module CampusService
    CAMPUSES = [
      {
        name: 'Bakersfield',
        slug: 'bakersfield',
        demo_email: ['bakersfield.edu'],
        org: 'csub'
      },
      {
        name: 'Chancellor',
        slug: 'chancellor',
        demo_email: ['calstate.edu'],
        org: 'co'
      },
      {
        name: 'Channel Islands',
        slug: 'channel',
        demo_email: ['ci.edu'],
        org: 'csuci'
      },
      {
        name: 'Chico',
        slug: 'chico',
        demo_email: ['chico.edu'],
        org: 'csuchico'
      },
      {
        name: 'Dominguez Hills',
        slug: 'dominguez',
        demo_email: ['dh.edu'],
        org: 'csudh'
      },
      {
        name: 'East Bay',
        slug: 'eastbay',
        demo_email: ['eb.edu'],
        org: 'csueastbay'
      },
      {
        name: 'Fresno',
        slug: 'fresno',
        demo_email: ['fresno.edu'],
        org: 'csufresno'
      },
      {
        name: 'Fullerton',
        slug: 'fullerton',
        demo_email: ['fullerton.edu'],
        org: 'fullerton'
      },
      {
        name: 'Humboldt',
        slug: 'humboldt',
        demo_email: ['humboldt.edu'],
        org: 'humboldt'
      },
      {
        name: 'Long Beach',
        slug: 'longbeach',
        demo_email: ['lb.edu'],
        org: 'csulb'
      },
      {
        name: 'Los Angeles',
        slug: 'losangeles',
        demo_email: ['la.edu'],
        org: 'calstatela'
      },
      {
        name: 'Maritime',
        slug: 'maritime',
        demo_email: ['csum.edu'],
        org: 'csum'
      },
      {
        name: 'Monterey Bay',
        slug: 'monterey',
        demo_email: ['csumb.edu'],
        org: 'csumb'
      },
      {
        name: 'Moss Landing',
        slug: 'mlml',
        demo_email: ['mlml.edu'],
        org: 'mlml'
      },
      {
        name: 'Northridge',
        slug: 'northridge',
        demo_email: ['csun.edu'],
        org: 'csun'
      },
      {
        name: 'Pomona',
        slug: 'pomona',
        demo_email: ['cpp.edu'],
        org: 'csupomona'
      },
      {
        name: 'Sacramento',
        slug: 'sacramento',
        demo_email: ['sacramento.edu'],
        org: 'csus'
      },
      {
        name: 'San Bernardino',
        slug: 'sanbernardino',
        demo_email: ['sacramento.edu'],
        org: 'csusb'
      },
      {
        name: 'San Diego',
        slug: 'sandiego',
        demo_email: ['sdsu.edu'],
        org: 'sdsu'
      },
      {
        name: 'San Francisco',
        slug: 'sanfrancisco',
        demo_email: ['sf.edu'],
        org: 'sfsu'
      },
      {
        name: 'San Jose',
        slug: 'sanjose',
        demo_email: ['sjsu.edu'],
        org: 'sjsu'
      },
      {
        name: 'San Luis Obispo',
        slug: 'sanluisobisbo',
        demo_email: ['calpoly.edu'],
        org: 'calpoly'
      },
      {
        name: 'San Marcos',
        slug: 'sanmarcos',
        demo_email: ['sanmarcos.edu'],
        org: 'csusm'
      },
      {
        name: 'Sonoma',
        slug: 'sonoma',
        demo_email: ['sonoma.edu'],
        org: 'sonoma'
      },
      {
        name: 'Stanislaus',
        slug: 'stanislaus',
        demo_email: ['stanislaus.edu'],
        org: 'csustan'
      }
    ].freeze

    #
    # Get campus slug from current shibboleth user
    #
    # @param [User] campus
    #
    # @return [String] the campus slug
    #
    def self.get_shib_user_campus(user)
      campus = nil
      CAMPUSES.each do |campus_info|
        if user.campus == campus_info[:org]
          campus = campus_info[:slug]
          break
        end
      end
      campus
    end

    #
    # Get campus slug from current demo user
    #
    # @param [User] campus
    #
    # @return [String] the campus slug
    #
    def self.get_demo_user_campus(user)
      campus = nil
      CAMPUSES.each do |campus_info|
        if user.email.end_with?(*campus_info[:demo_email])
          campus = campus_info[:slug]
          break
        end
      end
      campus
    end

    #
    # Get campus name from short code
    #
    # @param [String] campus_id short campus code, e.g., 'losangeles'
    #
    # @return [String] the campus name, e.g., 'Los Angeles'
    #
    def self.get_campus_name_from_id(campus_id)
      result = CAMPUSES.find do |campus|
        campus[:slug] == campus_id
      end

      raise 'Could not find campus name for ' + campus_id unless result.present?

      result[:name]
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
    # Extract campus name from Admin set name
    #
    # @param admin_set_name [String] the admin sets public name
    #
    # @return [String] the campus name
    #
    def self.get_campus_from_admin_set(admin_set_name)
      result = CAMPUSES.find do |campus|
        admin_set_name.include?(campus[:name])
      end

      raise 'No campus admin set found' unless result.present?

      result[:name]
    end

    #
    # Get campus slug from campus name
    #
    # @param campus_name [String] the campus name
    #
    # @return [String] the campus slug
    #
    def self.get_campus_slug_from_name(campus_name)
      CAMPUSES.select do |campus|
        campus[:name].downcase == campus_name.downcase
      end.first&.fetch(:slug)
    end

    #
    # All campus slugs
    #
    # @return [Array]
    #
    def self.all_campus_slugs
      CAMPUSES.map { |campus| campus[:slug] }
    end

    #
    # All campus names
    #
    # @return [Array]
    #
    def self.all_campus_names
      CAMPUSES.map { |campus| campus[:name] }
    end
  end
end
