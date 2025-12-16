require 'rails_helper'

RSpec.describe "Api::V1::VoiceGenerations", type: :request do
  describe "POST /api/v1/voice_generations" do
    let(:valid_params) { { voice_generation: { text: "Hello world" } } }

    it "creates a new voice generation and enqueues a job" do
      expect {
        post api_v1_voice_generations_path, params: valid_params
      }.to change(VoiceGeneration, :count).by(1)
      .and have_enqueued_job(GenerateVoiceJob)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['status']).to eq('pending')
    end

    it "returns error for invalid params" do
      expect {
        post api_v1_voice_generations_path, params: { voice_generation: { text: "" } }
      }.not_to change(VoiceGeneration, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET /api/v1/voice_generations" do
    let!(:generations) { create_list(:voice_generation, 3) }

    it "returns a list of generations" do
      get api_v1_voice_generations_path
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.length).to eq(3)
    end
  end

  describe "GET /api/v1/voice_generations/:id" do
      let(:generation) { create(:voice_generation) }
  
      it "returns the generation details" do
        get api_v1_voice_generation_path(generation)
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['id']).to eq(generation.id)
      end
  
      it "returns 404 for non-existent id" do
        get "/api/v1/voice_generations/999999"
        expect(response).to have_http_status(:not_found)
      end
  end
end
