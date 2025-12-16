class CreateVoiceGenerations < ActiveRecord::Migration[7.1]
  def change
    create_table :voice_generations do |t|
      t.text :text, null: false
      t.string :audio_url
      t.integer :status, default: 0, null: false # 0: pending, 1: processing, 2: completed, 3: failed
      t.jsonb :meta_data, default: {}
      t.text :error_message

      t.timestamps
    end

    add_index :voice_generations, :status
  end
end
