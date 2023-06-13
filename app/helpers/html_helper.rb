# frozen_string_literal: true
#
# Utilities to clean, decode, sanitize HTML
#
require 'htmlentities'

#
# HTML utilities
#
module HtmlHelper
  #
  # Strip out unwanted html, decode html entities and straighten smart quotes
  #
  # @param values [Array]         field values
  # @param allowed_tags [Array]   [optional] allowed tags
  #
  # @return [Array]  cleaned values as array
  #
  def self.clean_values(values, allowed_tags = [])
    # collapse values into one text
    text = values.join('')

    # remove unnecessary paragraphs
    text.sub!('<p></p>', '')
    allowed_tags.delete('p') if text.scan(%r{(?=</p>)}).count == 1

    # convert pseudo-html tags to html equivalent
    text.sub!('<italic>', '<em>')
    text.sub!('</italic>', '</em>')

    # strip tags and decode html entities
    text = Sanitize.new.sanitize(text, tags: allowed_tags)

    # convert remaining ampersand and smart quotes
    text.gsub!('&amp;', '&')
    text.gsub!(/[”“]/, '"')
    text.gsub!(/[‘’]/, "'")
    text = text.squish

    [text]
  end

  #
  # Sanitize Helper
  #
  class Sanitize
    include ActionView::Helpers::SanitizeHelper
  end
end
