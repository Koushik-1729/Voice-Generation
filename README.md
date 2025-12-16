# Voice Generation API

A Ruby on Rails application to generate voice audio from text using ElevenLabs API.

## Features

- **Text-to-Speech**: Generates audio using ElevenLabs.
- **Background Processing**: Uses Sidekiq for asynchronous generation.
- **Cloud Storage**: Stores audio files on Cloudinary.
- **API**: RESTful API for generating and retrieving voice requests.
- **Frontend**: Simple UI to interact with the service.

## Setup

1.  **Prerequisites**:
    - Ruby 3.x
    - PostgreSQL
    - Redis (for Sidekiq)

2.  **Installation**:
    ```bash
    bundle install
    yarn install # or npm install
    ```

3.  **Database**:
    ```bash
    rails db:create db:migrate
    ```

4.  **Environment Variables**:
    Copy `.env.template` to `.env` and fill in the values:
    - `ELEVENLABS_API_KEY`
    - `CLOUDINARY_CLOUD_NAME`, `CLOUDINARY_API_KEY`, `CLOUDINARY_API_SECRET`
    - `REDIS_URL`

## Running the App

1.  Start the Rails server and Sidekiq:
    ```bash
    bin/dev
    # OR
    rails s
    bundle exec sidekiq
    ```

2.  Visit `http://localhost:3000`

## API Usage

- **POST /api/v1/voice_generations**
    - Body: `{ "voice_generation": { "text": "Hello world" } }`
    - Response: `{ "id": 1, "status": "pending" }`

- **GET /api/v1/voice_generations/:id**
    - Response: `{ "id": 1, "status": "completed", "audio_url": "..." }`

## Testing

```bash
bundle exec rspec
```
