class CreateRawTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :raw_transactions do |t|
      t.string                :registr_uid, null: false
      t.string                :fini_customer_id, null: false
      t.string                :account_id, null: false
      t.datetime              :transaction_date, null: false
      t.datetime              :posted_on_date
      t.integer               :amount_in_cents, null: false
      t.string                :transaction_type, null: false
      t.bigint                :event_rec_id, null: false
      t.string                :event_type, null: false
      t.string                :status, null: false
      t.datetime              :received_on_date, null: false
      t.datetime              :sent_to_finsync
      t.json                  :raw_data, null: false

      t.timestamps
    end

    add_index :raw_transactions, :fini_customer_id, name: :raw_trans_fini_customer_id_idx, unique: false
    add_index :raw_transactions, :event_rec_id, name: :raw_trans_event_rec_id_idx, unique: true
    add_index :raw_transactions, :registr_uid, name: :raw_trans_registr_uid_idx, unique: false
    add_foreign_key :raw_transactions, :finicity_registrations, name: :raw_trans_registr_uid_uid_fk, column: :registr_uid, primary_key: "uid"
  end
end
