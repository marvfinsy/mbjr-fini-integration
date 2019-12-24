class CreateAccessTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :access_tokens do |t|
      t.string                :access_token, null: false
      t.datetime              :last_refresh_time

      t.timestamps
    end
  end
end
