class HomeController < ApplicationController
  def index
    @voice_generations = VoiceGeneration.order(created_at: :desc).limit(10)
  end
end
