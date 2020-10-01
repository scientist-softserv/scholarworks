# frozen_string_literal: true

require 'pp'

namespace :calstate do
  desc 'Create a rewrite map of handles to hyrax ids'
  task handles: :environment do
    CalState::Metadata::HandleMapper.new('/home/ec2-user/data/handles').run
  end
end
