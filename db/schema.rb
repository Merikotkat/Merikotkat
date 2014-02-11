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

ActiveRecord::Schema.define(version: 20140211093015) do

  create_table "images", force: true do |t|
    t.string   "filename"
    t.binary   "data"
    t.integer  "visitation_form_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "images", ["visitation_form_id"], name: "index_images_on_visitation_form_id"

  create_table "visitation_forms", force: true do |t|
    t.string   "photographer_name"
    t.datetime "visit_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "camera"
    t.string   "lens"
    t.string   "teleconverter"
    t.string   "municipality"
    t.string   "nest"
    t.integer  "nest_id"
    t.string   "photographer_id"
    t.string   "form_saver_id"
  end

end
