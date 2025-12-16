require 'rails_helper'

RSpec.describe GenerateVoiceJob, type: :job do
  include ActiveJob::TestHelper

  let(:voice_generation) { create(:voice_generation) }
  let(:eleven_labs_response) { "binary_audio_data" }
  let(:audio_url) { "http://cloudinary.com/audio.mp3" }

  before do
    allow_any_instance_of(ElevenLabsService).to receive(:generate_voice).and_return(eleven_labs_response)
    allow(StorageService).to receive(:upload_audio).and_return(audio_url)
  end

  it 'updates the status to completed and saves audio_url on success' do
    perform_enqueued_jobs do
      GenerateVoiceJob.perform_later(voice_generation.id)
    end

    voice_generation.reload
    expect(voice_generation.status).to eq('completed')
    expect(voice_generation.audio_url).to eq(audio_url)
  end

  it 'updates the status to failed on API error' do
    allow_any_instance_of(ElevenLabsService).to receive(:generate_voice).and_raise(StandardError.new("API Error"))

    perform_enqueued_jobs do
      GenerateVoiceJob.perform_later(voice_generation.id)
    end

    voice_generation.reload
    expect(voice_generation.status).to eq('failed')
    expect(voice_generation.error_message).to eq("API Error")
  end
end
