# Generated via
#  `rails generate hyrax:work Dataset`
module Hyrax
  class DatasetPresenter < Hyrax::WorkShowPresenter
    include CalState::PresenterBehavior
    delegate :investigator, to: :solr_document
  end
end
