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

ActiveRecord::Schema.define(version: 20150717230147) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "survey_iterations", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "sg_survey_id"
    t.text     "worksheet_header_row"
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
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "survey_questions", force: :cascade do |t|
    t.text     "metadata"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "sg_question_id"
    t.integer  "survey_iteration_id"
    t.integer  "survey_page_id"
    t.string   "title"
    t.string   "question_type",              default: "radio"
    t.integer  "previous_question_id"
    t.integer  "parent_question_id"
    t.string   "parent_question_dependency"
  end

end
