require 'rails_helper'

RSpec.describe VoiceGeneration, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(build(:voice_generation)).to be_valid
    end

    it 'is invalid without text' do
      expect(build(:voice_generation, text: nil)).not_to be_valid
    end
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(pending: 0, processing: 1, completed: 2, failed: 3) }
  end
end
