require 'rails_helper'

RSpec.describe UpdateUserDetailsInCommentsJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job) do
    described_class.perform_later(
      Faker::Internet.username(specifier: 3..32),
      Faker::Internet.username(specifier: 3..32),
      Faker::Avatar.image
    )
  end

  it 'queues the job' do
    expect { job }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  it 'is in default queue' do
    expect(described_class.new.queue_name).to eq('default')
  end

  it 'updates user details in comments' do
    comment = create(:comment)
    old_username = comment.user_name
    new_username = 'dude'
    new_avatar = 'https://example.com/avatar.jpg'

    perform_enqueued_jobs do
      described_class.perform_later(old_username, new_username, new_avatar)
    end

    comment.reload
    expect(comment.user_name).to eq new_username
    expect(comment.user_avatar).to eq new_avatar
  end

  it 'doesn\'t updates user details in comments with invalid input' do
    comment = create(:comment)
    old_username = comment.user_name
    new_username = ''
    new_avatar = 'https://example.com/avatar.jpg'

    expect(Rails.logger).to receive(:error).with(/Failed to update/)

    perform_enqueued_jobs do
      described_class.perform_later(old_username, new_username, new_avatar)
    end

    comment.reload
    expect(comment.user_name).to eq old_username
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end
