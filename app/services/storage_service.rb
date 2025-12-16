class StorageService
  def self.upload_audio(audio_data, filename = "voice_#{Time.now.to_i}")
    # Create a temp file to upload
    temp_file = Tempfile.new([filename, '.mp3'])
    temp_file.binmode
    temp_file.write(audio_data)
    temp_file.rewind

    begin
      upload = Cloudinary::Uploader.upload(temp_file.path, resource_type: :video) # Cloudinary treats audio as video usually, or raw
      upload['secure_url']
    ensure
      temp_file.close
      temp_file.unlink
    end
  end
end
