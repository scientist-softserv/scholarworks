#
# Shared presenter for CSU fields
#
module Hyrax
  class CsuPresenter < Hyrax::WorkShowPresenter
    delegate *FieldService.all, to: :solr_document
    delegate :description_formatted, to: :solr_document
    delegate :description_short, to: :solr_document
    delegate :title_formatted, to: :solr_document
    delegate :title_or_label, to: :solr_document

    def page_title
      "#{solr_document.title_or_label} | #{I18n.t('hyrax.product_name')}"
    end
  end
end
