# Generated via
#  `rails generate hyrax:work Publication`
module Hyrax
  class PublicationPresenter < Hyrax::WorkShowPresenter
    include CalState::PresenterBehavior
    delegate :editor,
             :publication_status, to: :solr_document
  end
end
