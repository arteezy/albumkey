class UpdateUserDetailsInCommentsJob < ActiveJob::Base
  queue_as :default

  def perform(old_email, new_email, new_avatar)
    Album.where('comments.user_email' => old_email).each do |album|
      album.comments.each do |comment|
        if comment.user_email == old_email
          comment.user_email = new_email
          comment.user_avatar = new_avatar
          unless comment.save
            Rails.logger.error('Failed to update user details in comments')
          end
        end
      end
    end
  end
end
