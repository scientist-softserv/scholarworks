#
# OVERRIDE class from hyrax v2.9.6
# Customization: Using campus from the work to get feature_work based on such campus.
#
module Hyrax
  class FeaturedWorksController < ApplicationController
    def create
      authorize! :create, FeaturedWork
      campus = Hyrax::WorkQueryService.new(id: params[:id]).work.campus.first
      @featured_work = FeaturedWork.new(work_id: params[:id], campus: campus)
      respond_to do |format|
        if @featured_work.save
          format.json { render json: @featured_work, status: :created }
        else
          format.json { render json: @featured_work.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      authorize! :destroy, FeaturedWork
      @featured_work = FeaturedWork.find_by(work_id: params[:id])
      @featured_work&.destroy

      respond_to do |format|
        format.json { head :no_content }
      end
    end
  end
end
