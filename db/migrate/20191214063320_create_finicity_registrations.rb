class CreateFinicityRegistrations < ActiveRecord::Migration[6.0]
  def change
    create_table :finicity_registrations do |t|
      t.string                :uid, null: false   
      t.integer               :profile_id, null: false
      t.string                :fini_customer_id

      t.timestamps
    end

    add_index :finicity_registrations, :uid, name: :fini_registr_uid_unique_idx, unique: true
    add_index :finicity_registrations, :fini_customer_id, name: :fini_registr_fini_customer_id_idx, unique: false
  end
end
