# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_22_052503) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_tokens", force: :cascade do |t|
    t.string "access_token", null: false
    t.datetime "last_refresh_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "finicity_registrations", force: :cascade do |t|
    t.string "uid", null: false
    t.integer "profile_id", null: false
    t.string "fini_customer_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["fini_customer_id"], name: "fini_registr_fini_customer_id_idx"
    t.index ["uid"], name: "fini_registr_uid_unique_idx", unique: true
  end

  create_table "raw_transactions", force: :cascade do |t|
    t.string "registr_uid", null: false
    t.string "fini_customer_id", null: false
    t.string "account_id", null: false
    t.datetime "transaction_date", null: false
    t.datetime "posted_on_date"
    t.integer "amount_in_cents", null: false
    t.string "transaction_type", null: false
    t.bigint "event_rec_id", null: false
    t.string "event_type", null: false
    t.string "status", null: false
    t.datetime "received_on_date", null: false
    t.datetime "sent_to_finsync"
    t.json "raw_data", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_rec_id"], name: "raw_trans_event_rec_id_idx", unique: true
    t.index ["fini_customer_id"], name: "raw_trans_fini_customer_id_idx"
    t.index ["registr_uid"], name: "raw_trans_registr_uid_idx"
  end

  add_foreign_key "raw_transactions", "finicity_registrations", column: "registr_uid", primary_key: "uid", name: "raw_trans_registr_uid_uid_fk"
end
