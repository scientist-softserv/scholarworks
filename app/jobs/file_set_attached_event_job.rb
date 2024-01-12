#
# OVERRIDE class from Hyrax v2.9.6
# Customization: Change action according to Hyrax original commit
#
class FileSetAttachedEventJob < ContentEventJob
  # Log the event to the fileset's and its container's streams
  def log_event(repo_object)
    repo_object.log_event(event)
    curation_concern.log_event(event)
  end

  def action
    #this is updated from Hyrax in original commit
    file_type = FileService.type(repo_object[:title].first)
    # need to get an object, seems like what pass in is just a copy reference
    object = ActiveFedora::Base.find(curation_concern.id)
    if (object.file_type.empty?)
      object.file_type = [file_type]
    else
      # this doesn't work
      # object.file_type << file_type
      object.file_type = curation_concern.file_type + [file_type]
    end
    object.save
    GlacierUploadService.upload(repo_object)
  end

  private

  def file_link
    link_to file_title, polymorphic_path(repo_object)
  end

  def work_link
    link_to work_title, polymorphic_path(curation_concern)
  end

  def file_title
    repo_object.title.first
  end

  def work_title
    curation_concern.title.first
  end

  def curation_concern
    repo_object.in_works.first
  end
end
