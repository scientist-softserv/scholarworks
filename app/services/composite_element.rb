# frozen_string_literal: true

#
# CompsositeElement field object
#
class CompositeElement

  NAME = 'name'
  EMAIL = 'email'
  INSTITUTION = 'institution'
  ORCID = 'orcid'
  ROLE = 'role'
  IDENTIFIER = 'identifier'

  def initialize(fields = nil)
    @fields = []
    @values = []
    if fields.nil? || fields.empty? || !fields.is_a?(Array)
      @fields << NAME
      @fields << EMAIL
      @fields << INSTITUTION
      @fields << ORCID
      @values << ''
      @values << ''
      @values << ''
      @values << ''
    else
      fields.each do |field|
        @fields << field
      end
    end
  end

  #
  # Composite element attribute
  #
  # @return [String|nil]
  #
  def get(attr)
    @fields.include?(attr) ? @values[@fields.index(attr)] : nil
  end


  #
  # Populate the element from Hyrax data
  #
  # @param element_string [String]  data containing (single) composite info
  #
  # @return [self]
  #
  def from_hyrax(element_string)
    element_string = ensure_string(element_string)
    @values = element_string.split(CompositeElement.field_separator)

    self
  end

  #
  # Populate the CompositeElement from Excel data
  #
  # @param element_string [String]  data containing (single) person info
  #
  # @return [self]
  #
  def from_export(element_string)
    element_string = ensure_string(element_string)
    subfields = element_string.split(CompositeElement.export_separator)

    num_fields = @fields.length
    subfields.each_with_index do |value, i|
      break if i >= num_fields

      if i.zero?
        @values[@fields.find_index(NAME)] = value
      elsif email?(value)
        @values[@fields.find_index(EMAIL)] = value
      elsif orcid?(value)
        @values[@fields.find_index(ORCID)] = value
      elsif institution?(value)
        @values[@fields.find_index(INSTITUTION)] = value
      end
    end

    self
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
  # Convert CompositeElement to string for csv export
  #
  # @return [String]
  #
  def to_export
    final = []
    @values.each do |value|
      next if value.squish.empty?

      final.append value
    end

    final.join(CompositeElement.export_separator)
  end

  #
  # Convert CompositeElement to string for Hyrax field
  #
  # @return [String]
  #
  def to_hyrax
    @values.join(CompositeElement.field_separator)
  end

  private

  #
  # Does this value follow the email pattern?
  #
  # @param email [String]
  #
  # @return [Boolean]
  #
  def email?(email)
    email =~ URI::MailTo::EMAIL_REGEXP
  end

  #
  # Does this value look like an institution?
  #
  # @param inst [String]
  #
  # @return [Boolean]   false if value contains @ or digit, true otherwise
  #
  def institution?(inst)
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
  def orcid?(orcid)
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

