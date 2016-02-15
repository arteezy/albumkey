require 'rails_helper'

RSpec.describe UpdateUserDetailsInCommentsJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job) { described_class.perform_later(Faker::Internet.email, Faker::Internet.email, Faker::Avatar.image) }

  it 'queues the job' do
    expect { job }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  it 'is in default queue' do
    expect(described_class.new.queue_name).to eq('default')
  end

  it 'updates user details in comments' do
    comment = create(:comment)
    old_email = comment.user_email
    new_email = 'example@gmail.com'
    new_avatar = 'https://example.com/avatar.jpg'

    perform_enqueued_jobs do
      described_class.perform_later(old_email, new_email, new_avatar)
    end

    comment.reload
    expect(comment.user_email).to eq 'example@gmail.com'
    expect(comment.user_avatar).to eq 'https://example.com/avatar.jpg'
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end
