# Usage
# bundle exec rake calstate:update_visibility[innput_file,work_file,model_type]
# bundle exec rake calstate:update_file_visibility[test.csv,file,thesis]
# bundle exec rake calstate:update_file_visibility[test.csv,work,thesis]
#
# work_file is used to indicate either the visibility change applies to the work or file
# model can be either Thesis,Publication,EducationalResource,DataSet.
# We will assume model is Thesis if not entered
# input_file is a csv file like test.csv
# input file consists of two columns, ID and visibility
# where visibility can be "open", "authenticated", or "restricted"
#
namespace :calstate do
  desc 'Update visibility of all attached files to work'
  task :update_visibility, %i[input_file work_file model_type] => [:environment] do |_t, args|
    input_file = args[:input_file] or raise 'No input file provided.'
    work_file = args[:work_file] ||= 'work'
    model_type = args[:model_type]
    file_attributes = {}
    model = get_model_type(model_type)
    rows = process_visibility_input(input_file)
    rows.each do |row|
      p "Processing work ID #{row['id']}"
      model.where(id: row['id']).each do |work|
        if work_file == 'work'
          work.visibility = row['visibility']
          work.save
        else
          work.file_sets.each do |file|
            file_attributes['visibility'] = row['visibility']
            user = User.find_by_user_key(work.depositor)
            actor = Hyrax::Actors::FileSetActor.new(file, user)
            actor.update_metadata(file_attributes)
          end
        end
      end
    end
  end

  # load the input spreadsheet and figure out work IDs and its visibility
  def process_visibility_input(csv_file)
    rows = []
    CSV.foreach(csv_file) do |row|
      next if row.length < 2

      value = {}
      value['id'] = row[0]
      value['visibility'] = row[1]
      # default to pubic if visibility is invalid
      case value['visibility']
      when Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
      when Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED
      else
        value['visibility'] = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      end
      rows << value
    end

    rows
  end

  # Figure out what type of work we need to process
  def get_model_type(type)
    return Thesis if type.nil? or type.length() == 0

    case type.downcase
    when 'thesis'
      return Thesis
    when 'publication'
      return Publication
    when 'educationalresource'
      return EducationalResource
    when 'dataset'
      return DataSet
    end
    return Thesis
  end
end
