class VoiceGeneration < ApplicationRecord
  enum status: { pending: 0, processing: 1, completed: 2, failed: 3 }

  validates :text, presence: true
end
