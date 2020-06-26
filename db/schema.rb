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

ActiveRecord::Schema.define(version: 2020_05_28_234911) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "claims", force: :cascade do |t|
    t.integer "client_id"
    t.integer "donation_id"
    t.string "qr_code"
    t.boolean "completed"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "time_claimed"
    t.boolean "canceled", default: false
  end

  create_table "clients", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "address_street"
    t.string "address_city"
    t.string "address_state"
    t.integer "address_zip"
    t.string "account_status"
    t.string "ethnicity"
    t.string "gender"
    t.integer "document_id"
    t.string "phone_number"
    t.string "profile_pic_link"
  end

  create_table "documents", force: :cascade do |t|
    t.string "title"
    t.text "location"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "donations", force: :cascade do |t|
    t.string "food_name"
    t.string "measurement"
    t.integer "per_person"
    t.integer "total_servings"
    t.integer "donor_id"
    t.integer "duration_minutes"
    t.string "image_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "canceled", default: false
    t.string "pickup_location"
  end

  create_table "donors", force: :cascade do |t|
    t.string "organization_name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "address_street"
    t.string "address_city"
    t.string "address_state"
    t.integer "address_zip"
    t.string "business_license"
    t.string "account_status"
    t.string "pickup_instructions"
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "business_phone_number"
    t.integer "business_doc_id"
    t.string "profile_pic_link"
  end

  create_table "password_resets", force: :cascade do |t|
    t.string "reset_token"
    t.datetime "reset_sent_at"
    t.string "ip"
    t.string "resettable_type"
    t.bigint "resettable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["resettable_type", "resettable_id"], name: "index_password_resets_on_resettable_type_and_resettable_id"
  end

end
