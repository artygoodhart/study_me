# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161127173817) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "non_user_participants", force: :cascade do |t|
    t.date     "date_of_birth"
    t.string   "gender"
    t.string   "recruitment_method"
    t.date     "recruitment_date",   null: false
    t.integer  "study_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["study_id"], name: "index_non_user_participants_on_study_id", using: :btree
  end

  create_table "participant_attributes", force: :cascade do |t|
    t.string   "occupation"
    t.string   "country_of_residence"
    t.string   "managed_account_id"
    t.integer  "participant_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["participant_id"], name: "index_participant_attributes_on_participant_id", using: :btree
  end

  create_table "participation_requirements", force: :cascade do |t|
    t.integer  "requirement_id"
    t.integer  "participation_id"
    t.boolean  "checked",          default: false, null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["participation_id"], name: "index_participation_requirements_on_participation_id", using: :btree
    t.index ["requirement_id"], name: "index_participation_requirements_on_requirement_id", using: :btree
  end

  create_table "participations", force: :cascade do |t|
    t.integer  "participant_id"
    t.integer  "study_id"
    t.integer  "timeslot_id"
    t.boolean  "accepted"
    t.boolean  "paid",                   default: false, null: false
    t.boolean  "notify_published_study"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.index ["participant_id"], name: "index_participations_on_participant_id", using: :btree
    t.index ["study_id"], name: "index_participations_on_study_id", using: :btree
    t.index ["timeslot_id"], name: "index_participations_on_timeslot_id", using: :btree
  end

  create_table "ratings", force: :cascade do |t|
    t.integer  "rating",              null: false
    t.integer  "user_id"
    t.integer  "user_being_rated_id"
    t.integer  "study_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["study_id"], name: "index_ratings_on_study_id", using: :btree
    t.index ["user_being_rated_id"], name: "index_ratings_on_user_being_rated_id", using: :btree
    t.index ["user_id"], name: "index_ratings_on_user_id", using: :btree
  end

  create_table "requirements", force: :cascade do |t|
    t.string   "text",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "requirements_studies", force: :cascade do |t|
    t.integer "requirement_id"
    t.integer "study_id"
    t.boolean "checked",        default: true, null: false
    t.index ["requirement_id"], name: "index_requirements_studies_on_requirement_id", using: :btree
    t.index ["study_id"], name: "index_requirements_studies_on_study_id", using: :btree
  end

  create_table "researcher_attributes", force: :cascade do |t|
    t.integer  "wallet_total",  default: 0, null: false
    t.string   "department"
    t.integer  "researcher_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["researcher_id"], name: "index_researcher_attributes_on_researcher_id", using: :btree
  end

  create_table "studies", force: :cascade do |t|
    t.string   "background_photo_file_name"
    t.string   "background_photo_content_type"
    t.integer  "background_photo_file_size"
    t.datetime "background_photo_updated_at"
    t.string   "pdf_attachment_file_name"
    t.string   "pdf_attachment_content_type"
    t.integer  "pdf_attachment_file_size"
    t.datetime "pdf_attachment_updated_at"
    t.string   "study_web_link"
    t.string   "title",                                                        null: false
    t.string   "aim",                                                          null: false
    t.integer  "reward_per_participant_pennies",  default: 0,                  null: false
    t.string   "reward_per_participant_currency", default: "GBP",              null: false
    t.integer  "number_of_participants",                                       null: false
    t.string   "location",                                                     null: false
    t.integer  "duration",                                                     null: false
    t.text     "tags",                            default: [],                              array: true
    t.boolean  "timeslots_finalised"
    t.boolean  "paid",                            default: false,              null: false
    t.boolean  "featured",                        default: false,              null: false
    t.integer  "min_age"
    t.integer  "max_age"
    t.text     "gender",                          default: ["male", "female"],              array: true
    t.string   "building_name"
    t.string   "building_number"
    t.string   "street_name"
    t.string   "town"
    t.string   "postcode"
    t.string   "country",                         default: "UK",               null: false
    t.integer  "researcher_id"
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
    t.index ["researcher_id"], name: "index_studies_on_researcher_id", using: :btree
  end

  create_table "timeslots", force: :cascade do |t|
    t.datetime "from",       null: false
    t.datetime "to",         null: false
    t.integer  "study_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["study_id"], name: "index_timeslots_on_study_id", using: :btree
  end

  create_table "universities", force: :cascade do |t|
    t.string   "domain_name",                                   null: false
    t.string   "name",                                          null: false
    t.string   "contact_name",                                  null: false
    t.string   "contact_email",                                 null: false
    t.string   "contact_number",                                null: false
    t.integer  "price_per_researcher_pennies",  default: 0,     null: false
    t.string   "price_per_researcher_currency", default: "GBP", null: false
    t.integer  "billing_date"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "type"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "name"
    t.date     "date_of_birth"
    t.string   "gender"
    t.string   "referrer"
    t.integer  "university_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["university_id"], name: "index_users_on_university_id", using: :btree
  end

end
