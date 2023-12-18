# frozen_string_literal: true
#
# OVERRIDE class from blacklight v6.25.0
# Customization: To include ViewHelperOverride, RangeLimitHelper, and RenderConstraintsOverride
#
class SearchHistoryController < ApplicationController
  include Blacklight::SearchHistory

  helper BlacklightRangeLimit::ViewHelperOverride
  helper RangeLimitHelper
  helper BlacklightAdvancedSearch::RenderConstraintsOverride
end
