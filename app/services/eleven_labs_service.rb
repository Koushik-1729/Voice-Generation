class ElevenLabsService
  include HTTParty
  base_uri 'https://api.elevenlabs.io/v1'

  def initialize(api_key = ENV['ELEVENLABS_API_KEY'])
    @options = { headers: { "xi-api-key" => api_key, "Content-Type" => "application/json" } }
  end

  def generate_voice(text, voice_id = "21m00Tcm4TlvDq8ikWAM") # Pre-defined voice ID (Rachel)
    response = self.class.post("/text-to-speech/#{voice_id}", @options.merge(body: { text: text }.to_json))
    
    if response.success?
      response.body # This is the binary audio data
    else
      raise "ElevenLabs API Error: #{response.code} - #{response.body}"
    end
  end
end
