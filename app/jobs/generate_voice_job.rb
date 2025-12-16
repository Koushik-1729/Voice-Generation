class GenerateVoiceJob < ApplicationJob
  queue_as :default

  def perform(voice_generation_id)
    voice_generation = VoiceGeneration.find_by(id: voice_generation_id)
    return unless voice_generation

    voice_generation.processing!
    begin
      # 1. Generate Voice
      # Use a real service call.
      eleven_labs = ElevenLabsService.new
      audio_data = eleven_labs.generate_voice(voice_generation.text)

      # 2. Upload to Storage
      public_url = StorageService.upload_audio(audio_data, "voice_#{voice_generation.id}")

      # 3. Update Record
      voice_generation.update!(audio_url: public_url, status: :completed)
    rescue StandardError => e
      voice_generation.update!(status: :failed, error_message: e.message)
      Rails.logger.error("Voice Generation Failed: #{e.message}")
    end
  end
end
