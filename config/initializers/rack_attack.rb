class Rack::Attack
  # Throttle requests to 5 requests per minute per IP address
  throttle('req/ip', limit: 5, period: 1.minute) do |req|
    req.ip if req.path == '/api/v1/voice_generations' && req.post?
  end

  # Response with 429 when throttled
  self.throttled_responder = lambda do |env|
    [ 429,  {}, ["Rate limit exceeded. Please try again later.\n"]]
  end
end
