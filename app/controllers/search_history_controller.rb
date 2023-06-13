# frozen_string_literal: true
#
# Customization: To include ViewHelperOverride, RangeLimitHelper, and RenderConstraintsOverride
# OVERRIDE class from Blacklight v6.25.0
#
class SearchHistoryController < ApplicationController
  include Blacklight::SearchHistory

  helper BlacklightRangeLimit::ViewHelperOverride
  helper RangeLimitHelper
  helper BlacklightAdvancedSearch::RenderConstraintsOverride
end
