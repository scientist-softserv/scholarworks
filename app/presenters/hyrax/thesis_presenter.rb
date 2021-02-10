# Generated via
#  `rails generate hyrax:work Thesis`
module Hyrax
  class ThesisPresenter < Hyrax::WorkShowPresenter
    include CalState::PresenterBehavior
    delegate :advisor,
             :committee_member,
             :degree_level,
             :degree_name,
             :granting_institution, to: :solr_document
  end
end
