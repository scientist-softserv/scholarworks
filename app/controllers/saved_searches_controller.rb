# frozen_string_literal: true
#
# OVERRIDE class from blacklight v6.25.0
# Customization: To include BlacklightAdvancedSearch::RenderConstraintsOverride
#
class SavedSearchesController < ApplicationController
  include Blacklight::SavedSearches

  helper BlacklightAdvancedSearch::RenderConstraintsOverride
end
