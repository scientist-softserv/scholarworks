require 'rails_helper'

RSpec.describe GlacierUploadService do
  let(:uploaded_file) do
    hydra_file = Hydra::PCDM::File.create
    File.open(File.join(Rails.root, "spec", "fixtures", "AS362010FILMD53.pdf"), 'r') do |f|
      hydra_file.content = f.read
    end
    hydra_file
  end

  let(:glacier_locations){ [] }

  let(:s3_service_mock) do
    double("AWS::S3::Client", put_object: {})      
  end

  before do
    GlacierUploadService.stub(:client){ s3_service_mock }
  end

  context "with original_file" do
    let(:file_set){ double(:file_set, original_file: uploaded_file, glacier_location: glacier_locations) }


    it "uploads new file" do
      expect(file_set).to receive(:update)
      GlacierUploadService.upload(file_set)
    end
  end

  context "no original_file" do
    let(:file_set){ double(:file_set, original_file: nil, glacier_location: glacier_locations) }

    it "doesn't upload " do
      expect(file_set).to_not receive(:update)
      GlacierUploadService.upload(file_set)
    end
  end

end
