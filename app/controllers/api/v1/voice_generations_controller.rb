class Api::V1::VoiceGenerationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @voice_generations = VoiceGeneration.order(created_at: :desc).limit(20)
    render json: @voice_generations
  end

  def create
    @voice_generation = VoiceGeneration.new(voice_generation_params)

    if @voice_generation.save
      GenerateVoiceJob.perform_later(@voice_generation.id)
      render json: { 
        id: @voice_generation.id, 
        status: @voice_generation.status, 
        message: "Voice generation started" 
      }, status: :created
    else
      render json: { errors: @voice_generation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    @voice_generation = VoiceGeneration.find(params[:id])
    render json: @voice_generation
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Not found" }, status: :not_found
  end

  private

  def voice_generation_params
    params.require(:voice_generation).permit(:text)
  end
end
