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

ActiveRecord::Schema.define(version: 20140415092136) do

  create_table "audit_log_entries", force: true do |t|
    t.string   "username"
    t.string   "userid"
    t.datetime "timestamp"
    t.string   "operation"
    t.integer  "visitation_form_id"
  end

  add_index "audit_log_entries", ["visitation_form_id"], name: "index_audit_log_entries_on_visitation_form_id", using: :btree

  create_table "birds", force: true do |t|
    t.string   "gender"
    t.integer  "shyness"
    t.string   "left_ring_code"
    t.string   "left_ring_color"
    t.string   "right_ring_code"
    t.string   "right_ring_color"
    t.integer  "visitation_form_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "gender_determination_method"
    t.integer  "ringed"
  end

  add_index "birds", ["visitation_form_id"], name: "index_birds_on_visitation_form_id", using: :btree

  create_table "images", force: true do |t|
    t.string   "filename"
    t.binary   "data"
    t.integer  "visitation_form_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "checksum"
    t.integer  "category_id"
    t.integer  "image_type"
    t.string   "upload_id"
    t.binary   "thumbnaildata"
    t.string   "content_type"
    t.integer  "bird_id"
  end

  add_index "images", ["bird_id"], name: "index_images_on_bird_id", using: :btree
  add_index "images", ["visitation_form_id"], name: "index_images_on_visitation_form_id", using: :btree

  create_table "owners", force: true do |t|
    t.string  "owner_name"
    t.string  "owner_id"
    t.integer "visitation_form_id"
  end

  add_index "owners", ["visitation_form_id"], name: "index_owners_on_visitation_form_id", using: :btree

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
    t.boolean  "sent"
    t.boolean  "approved"
    t.string   "species_id"
    t.string   "additional_info"
  end

end
