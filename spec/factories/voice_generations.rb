FactoryBot.define do
  factory :voice_generation do
    text { Faker::Lorem.sentence }
    status { :pending }
    
    trait :completed do
      status { :completed }
      audio_url { Faker::Internet.url(host: 'cloudinary.com', path: '/video/upload/v12345/voice.mp3') }
    end

    trait :failed do
      status { :failed }
      error_message { "Something went wrong" }
    end
  end
end
