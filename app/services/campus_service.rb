# frozen_string_literal: true

#
# Provides essential methods for getting the normalized campus name
#
module CampusService
  CAMPUSES = [
    {
      name: 'Bakersfield',
      slug: 'bakersfield',
      demo_email: ['bakersfield.edu'],
      org: 'csub',
      full: 'California State University, Bakersfield'
    },
    {
      name: 'Chancellor',
      slug: 'chancellor',
      demo_email: ['calstate.edu'],
      org: 'co',
      full: 'California State University, Office of the Chancellor'
    },
    {
      name: 'Channel Islands',
      slug: 'channel',
      demo_email: ['ci.edu'],
      org: 'csuci',
      full: 'California State University, Channel Islands'
    },
    {
      name: 'Chico',
      slug: 'chico',
      demo_email: ['chico.edu'],
      org: 'csuchico',
      full: 'California State University, Chico'
    },
    {
      name: 'Dominguez Hills',
      slug: 'dominguez',
      demo_email: ['dh.edu'],
      org: 'csudh',
      full: 'California State University, Dominguez Hills'
    },
    {
      name: 'East Bay',
      slug: 'eastbay',
      demo_email: ['eb.edu'],
      org: 'csueastbay',
      full: 'California State University, East Bay'
    },
    {
      name: 'Fresno',
      slug: 'fresno',
      demo_email: ['fresno.edu'],
      org: 'csufresno',
      full: 'California State University, Fresno'
    },
    {
      name: 'Fullerton',
      slug: 'fullerton',
      demo_email: ['fullerton.edu'],
      org: 'fullerton',
      full: 'California State University, Fullerton'
    },
    {
      name: 'Humboldt',
      slug: 'humboldt',
      demo_email: ['humboldt.edu'],
      org: 'humboldt',
      full: 'California State Polytechnic University, Humboldt'
    },
    {
      name: 'Long Beach',
      slug: 'longbeach',
      demo_email: ['lb.edu'],
      org: 'csulb',
      full: 'California State University, Long Beach'
    },
    {
      name: 'Los Angeles',
      slug: 'losangeles',
      demo_email: ['la.edu'],
      org: 'calstatela',
      full: 'California State University, Los Angeles'
    },
    {
      name: 'Maritime',
      slug: 'maritime',
      demo_email: ['csum.edu'],
      org: 'csum',
      full: 'California State University Maritime Academy'
    },
    {
      name: 'Monterey Bay',
      slug: 'monterey',
      demo_email: ['csumb.edu'],
      org: 'csumb',
      full: 'California State University, Monterey Bay'
    },
    {
      name: 'Moss Landing',
      slug: 'mlml',
      demo_email: ['mlml.edu'],
      org: 'mlml',
      full: 'Moss Landing Marine Laboratories'
    },
    {
      name: 'Northridge',
      slug: 'northridge',
      demo_email: ['csun.edu'],
      org: 'csun',
      full: 'California State University, Northridge'
    },
    {
      name: 'Pomona',
      slug: 'pomona',
      demo_email: ['cpp.edu'],
      org: 'csupomona',
      full: 'California State Polytechnic University, Pomona'
    },
    {
      name: 'Sacramento',
      slug: 'sacramento',
      demo_email: ['sacramento.edu'],
      org: 'csus',
      full: 'California State University, Sacramento'
    },
    {
      name: 'San Bernardino',
      slug: 'sanbernardino',
      demo_email: ['sb.edu'],
      org: 'csusb',
      full: 'California State University, San Bernardino'
    },
    {
      name: 'San Diego',
      slug: 'sandiego',
      demo_email: ['sd.edu'],
      org: 'sdsu',
      full: 'San Diego State University'
    },
    {
      name: 'San Francisco',
      slug: 'sanfrancisco',
      demo_email: ['sf.edu'],
      org: 'sfsu',
      full: 'San Francisco State University'
    },
    {
      name: 'San Jose',
      slug: 'sanjose',
      demo_email: ['sjsu.edu'],
      org: 'sjsu',
      full: 'San Jose State University'
    },
    {
      name: 'San Luis Obispo',
      slug: 'slo',
      demo_email: ['calpoly.edu'],
      org: 'calpoly',
      full: 'California Polytechnic State University, San Luis Obispo'
    },
    {
      name: 'San Marcos',
      slug: 'sanmarcos',
      demo_email: ['sanmarcos.edu'],
      org: 'csusm',
      full: 'California State University, San Marcos'
    },
    {
      name: 'Sonoma',
      slug: 'sonoma',
      demo_email: ['sonoma.edu'],
      org: 'sonoma',
      full: 'Sonoma State University'
    },
    {
      name: 'Stanislaus',
      slug: 'stanislaus',
      demo_email: ['stanislaus.edu'],
      org: 'csustan',
      full: 'California State University, Stanislaus'
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
  # Get campus name from user email
  #
  # @param [email]
  #
  # @return [String] the campus name
  #
  def self.get_demo_user_campus_name_from_email(email)
    campus = nil
    CAMPUSES.each do |campus_info|
      if email.end_with?(*campus_info[:demo_email])
        campus = campus_info[:name]
        break
      end
    end
    campus
  end

  # Get campus name from short code
  #
  # @param [String] campus_id short campus code, e.g., 'losangeles'
  #
  # @return [String] the campus name, e.g., 'Los Angeles'
  #
  def self.get_name_from_slug(campus_id)
    find(:slug, campus_id, :name)
  end

  #
  # Get campus slug from controller
  #
  # @param controller [ApplicationController] the current controller
  #
  # @return [String] the campus slug
  #
  def self.get_campus_from_controller(controller)
    # if the record has a campus already, use that
    if controller.class.method_defined?(:curation_concern)
      campus = controller.curation_concern.campus.first.dup.to_s
      return get_slug_from_name(campus) unless campus.blank?
    end

    # otherwise, this is a new record so use user's campus
    campus = get_shib_user_campus(controller.current_user)
    return campus unless campus.blank?

    campus = get_demo_user_campus(controller.current_user)
    return campus unless campus.blank?

    # user has no campus (?!), so use default
    ''
  end

  #
  # Ensure campus name is in controlled list
  #
  # @param campus_name [String]  the name of the campus
  #
  # @return [String] the campus name
  #
  def self.ensure_campus_name(campus_name)
    find(:name, campus_name, :name)
  end

  #
  # Get campus slug from campus name
  #
  # @param campus_name [String] the campus name
  #
  # @return [String] the campus slug
  #
  def self.get_slug_from_name(campus_name)
    find(:name, campus_name, :slug)
  end

  #
  # Get full campus name from (place) name
  #
  # @param campus_name [String] the campus name
  #
  # @return [String] the full campus name
  #
  def self.get_full_from_name(campus_name)
    find(:name, campus_name, :full)
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

  #
  # Search the CAMPUSES array for a value.
  #
  # Search is case insensitive.
  #
  # @param key [Symbol]           field to search on
  # @param term [String]          search term
  # @param return_field [Symbol]  the field to return value from
  #
  # @return [String]
  #
  def self.find(key, term, return_field)
    result = CAMPUSES.find do |campus|
      campus[key].to_s.downcase == term.to_s.downcase
    end

    unless result.present?
      raise "Could not find `#{key}:#{term}` in CampusService"
    end

    result[return_field]
  end
end
