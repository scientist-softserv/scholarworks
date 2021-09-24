# frozen_string_literal: true

#
# Person field object
#
class Person
  #
  # New Person
  #
  # @param name [String]         [optional] personal name
  # @param email [String]        [optional] email
  # @param institution [String]  [optional] institutional affiliation
  # @param orcid [String]        [optional] ORCID ID
  #
  def initialize(name = '', email = '', institution = '', orcid = '')
    @fields = []
    @fields[0] = name
    @fields[1] = email
    @fields[2] = institution
    @fields[3] = orcid
  end

  #
  # Populate the Person from Hyrax data
  #
  # @param person_string [String]  data containing (single) person info
  #
  # @return [self]
  #
  def from_hyrax(person_string)
    person_string = ensure_string(person_string)
    @fields = person_string.split(Person.field_separator)

    self
  end

  #
  # Populate the Person from Excel data
  #
  # @param person_string [String]  data containing (single) person info
  #
  # @return [self]
  #
  def from_export(person_string)
    person_string = ensure_string(person_string)
    subfields = person_string.split(Person.export_separator)

    x = 0 # first value is always the name

    subfields.each do |value|
      if x.zero?
        @fields[0] = value
      elsif is_email?(value)
        @fields[1] = value
      elsif is_institution?(value)
        @fields[2] = value
      elsif is_orcid?(value)
        @fields[3] = value
      end
      x += 1
    end

    self
  end

  #
  # Personal name
  #
  # @return [String|nil]
  #
  def name
    @fields[0]
  end

  #
  # Email
  #
  # @return [String|nil]
  #
  def email
    @fields[1]
  end

  #
  # Institution
  #
  # @return [String|nil]
  #
  def institution
    @fields[2]
  end

  #
  # ORCID ID
  #
  # @return [String|nil]
  #
  def orcid
    @fields[3]
  end

  #
  # Fedora field separator
  #
  # @return [String]
  #
  def self.field_separator
    ':::'
  end

  #
  # Field separator for export files
  #
  # @return [String]
  #
  def self.export_separator
    '^^'
  end

  #
  # Convert person to string for csv export
  #
  # @return [String]
  #
  def to_export
    final = []
    @fields.each do |value|
      next if value.squish.empty?

      final.append value
    end

    final.join(Person.export_separator)
  end

  #
  # Convert person to string for Hyrax field
  #
  # @return [String]
  #
  def to_hyrax
    @fields.join(Person.field_separator)
  end

  private

  #
  # Does this value follow the email pattern?
  #
  # @param email [String]
  #
  # @return [Boolean]
  #
  def is_email?(email)
    email =~ URI::MailTo::EMAIL_REGEXP
  end

  #
  # Does this value look like an institution?
  #
  # @param inst [String]
  #
  # @return [Boolean]   false if value contains @ or digit, true otherwise
  #
  def is_institution?(inst)
    return false if inst.include?('@')
    return false if inst.scan(/D/).count.positive?

    true
  end

  #
  # Does this value follow the ORCID ID pattern?
  #
  # @param orcid [String]
  #
  # @return [Boolean]
  #
  def is_orcid?(orcid)
    CreatorOrcidValidator.match([orcid])
  end

  #
  # Ensure the value is a string (or nil), otherwise raise exception
  #
  # @param value [String|Object]
  #
  # @return [String]
  #
  def ensure_string(value)
    unless value.is_a?(String) || value.nil?
      raise 'Value to populate Person must be string, ' \
            'you provided ' + value.class.name
    end

    value.to_s.squish
  end
end

