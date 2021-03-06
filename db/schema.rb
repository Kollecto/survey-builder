# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150730195435) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "survey_iterations", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
    t.string   "sg_survey_id"
    t.text     "worksheet_header_row"
    t.datetime "published_to_sg_at"
    t.datetime "publish_to_sg_started_at"
    t.datetime "publish_to_sg_queued_at"
    t.string   "sg_publishing_jid"
    t.datetime "publish_to_sg_cancelled_at"
    t.datetime "delete_from_sg_queued_at"
    t.datetime "delete_from_sg_started_at"
    t.datetime "delete_from_sg_completed_at"
    t.string   "delete_from_sg_jid"
    t.datetime "import_from_google_queued_at"
    t.datetime "import_from_google_started_at"
    t.datetime "import_from_google_completed_at"
    t.string   "import_from_google_jid"
    t.integer  "creator_id"
    t.string   "google_spreadsheet_id"
    t.string   "google_worksheet_url"
    t.datetime "import_from_google_failed_at"
    t.integer  "google_worksheet_header_row_index",                  default: 0
    t.integer  "google_worksheet_filtering_column_index"
    t.string   "google_worksheet_filtering_column_value"
    t.integer  "google_worksheet_art_attributes_start_column_index"
    t.integer  "google_worksheet_art_attributes_end_column_index"
    t.datetime "deletion_queued_at"
    t.datetime "deletion_started_at"
    t.datetime "deletion_failed_at"
  end

  create_table "survey_options", force: :cascade do |t|
    t.string   "title"
    t.string   "reporting_value"
    t.text     "metadata"
    t.string   "sg_option_id"
    t.integer  "survey_question_id"
    t.integer  "survey_page_id"
    t.integer  "survey_iteration_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "survey_pages", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "sg_page_id"
    t.integer  "survey_iteration_id"
    t.text     "metadata"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.datetime "imported_from_google_at"
  end

  create_table "survey_questions", force: :cascade do |t|
    t.text     "metadata"
    t.integer  "survey_iteration_id"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "sg_question_id"
    t.integer  "survey_page_id"
    t.string   "title"
    t.string   "question_type",              default: "radio"
    t.integer  "previous_question_id"
    t.integer  "parent_question_id"
    t.string   "parent_question_dependency"
  end

  create_table "survey_submissions", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "submission"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.integer  "survey_iteration_id"
    t.integer  "current_page_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "taste_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taste_categories_users", id: false, force: :cascade do |t|
    t.integer "user_id",           null: false
    t.integer "taste_category_id", null: false
  end

  add_index "taste_categories_users", ["taste_category_id", "user_id"], name: "index_taste_categories_users_on_taste_category_id_and_user_id", using: :btree
  add_index "taste_categories_users", ["user_id", "taste_category_id"], name: "index_taste_categories_users_on_user_id_and_taste_category_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",     null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
    t.string   "first_name"
    t.string   "role",                   default: "User"
    t.datetime "google_auth_expires_at"
    t.string   "google_access_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
