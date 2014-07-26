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

ActiveRecord::Schema.define(version: 20140514035029) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"

  create_table "links", id: false, force: true do |t|
    t.string   "uuid",        limit: 36
    t.string   "node_a_uuid", limit: 36
    t.string   "node_b_uuid", limit: 36
    t.integer  "direction"
    t.datetime "activated"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "links", ["direction"], name: "index_links_on_direction", using: :btree
  add_index "links", ["node_a_uuid"], name: "index_links_on_node_a_uuid", using: :btree
  add_index "links", ["node_b_uuid"], name: "index_links_on_node_b_uuid", using: :btree
  add_index "links", ["uuid"], name: "index_links_on_uuid", unique: true, using: :btree

  create_table "nodes", id: false, force: true do |t|
    t.string   "uuid",        limit: 36
    t.text     "title",                  null: false
    t.text     "description"
    t.datetime "activated"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "nodes", ["title"], name: "index_nodes_on_title", using: :btree
  add_index "nodes", ["uuid"], name: "index_nodes_on_uuid", unique: true, using: :btree

end
