class Import < ApplicationRecord
  validates :user_email, presence: true
  validates :filename, presence: true

  enum :status, { 
    pending: 'pending', 
    processing: 'processing', 
    completed: 'completed', 
    failed: 'failed' 
  }, default: 'pending'
  
  def duration
    return nil unless started_at && finished_at
    finished_at - started_at
  end
end

