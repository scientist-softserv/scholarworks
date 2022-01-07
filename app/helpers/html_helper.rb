# frozen_string_literal: true

module HtmlHelper
  #
  # HTML utilities
  #

  def self.get_rid_style_attribute(arr)
    # pattern 1 <p style="p_style1">p_style1_text</p><
    # pattern 2 <p style='p_style2'>p_style2_text</p>
    # pattern 3 <br style=\"color: #000000; text-decoration: none;\" />
    combined_val = arr.join('').gsub(/(style=("|'|\\")([^"'])+("|'))/i, '')
    filter_arr = []
    filter_arr[0] = combined_val
    filter_arr
  end

end
