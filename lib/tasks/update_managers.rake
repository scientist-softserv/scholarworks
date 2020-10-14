# Usage
# bundle exec rake calstate:update_manager["pc289j04q","San Francisco","thesis|dataset"]
#
# admin_set_id and campus are required fields where model_type is optional. All four
# models (Thesis, Publication, Dataset, EducationalResource] will be used if model_type
# is not provided and model_type is not case sensitive.
# It will find all current users with manage access and update to the work.
#

namespace :calstate do
  desc 'Update managers to work'
  task :update_managers, %i[admin_set_id campus model_type] => [:environment] do |_t, args|
    admin_set_id = args[:admin_set_id] or raise 'No admin set ID provided'
    campus_name = args[:campus] or raise 'No campus name provided'
    model_str = args[:model_type]

    model_types = get_model_types(model_str)
    p "Model types: #{model_types}"

    model_types.each do |model|
      model.where(campus: campus_name).each do |work|
        work = add_managers(work, admin_set_id)
        work.save
      end
    end
  end
end
