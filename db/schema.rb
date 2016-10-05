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

ActiveRecord::Schema.define(version: 20161004164508) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "containers", force: :cascade do |t|
    t.string   "name",                    null: false
    t.text     "description"
    t.integer  "parent_id"
    t.integer  "lft",                     null: false
    t.integer  "rgt",                     null: false
    t.integer  "depth",       default: 0, null: false
    t.integer  "user_id",                 null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["lft"], name: "index_containers_on_lft", using: :btree
    t.index ["parent_id"], name: "index_containers_on_parent_id", using: :btree
    t.index ["rgt"], name: "index_containers_on_rgt", using: :btree
    t.index ["user_id"], name: "index_containers_on_user_id", using: :btree
  end

  create_table "items", force: :cascade do |t|
    t.text     "name",                     null: false
    t.text     "description"
    t.integer  "container_id",             null: false
    t.integer  "count",        default: 1, null: false
    t.datetime "last_used_at"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["container_id"], name: "index_items_on_container_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_foreign_key "containers", "containers", column: "parent_id"
  add_foreign_key "containers", "users"
  add_foreign_key "items", "containers"
end
