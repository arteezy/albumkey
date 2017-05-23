class UpdateUserDetailsInCommentsJob < ActiveJob::Base
  queue_as :default

  def perform(old_username, new_username, new_avatar)
    Album.where('comments.user_name' => old_username).each do |album|
      album.comments.each do |comment|
        if comment.user_name == old_username
          comment.user_name = new_username
          comment.user_avatar = new_avatar
          unless comment.save
            Rails.logger.error('Failed to update user details in comments')
          end
        end
      end
    end
  end
end
