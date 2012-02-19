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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120218224523) do

  create_table "nodes", :id => false, :force => true do |t|
    t.string       "uuid",          :limit => 36
    t.string       "title",                       :null => false
    t.string       "description"
    t.string_array "parent_uuids"
    t.string_array "child_uuids"
    t.string_array "sibling_uuids"
    t.datetime     "created_at",                  :null => false
    t.datetime     "updated_at",                  :null => false
  end

  add_index "nodes", ["child_uuids"], :name => "index_nodes_on_child_uuids"
  add_index "nodes", ["parent_uuids"], :name => "index_nodes_on_parent_uuids"
  add_index "nodes", ["sibling_uuids"], :name => "index_nodes_on_sibling_uuids"
  add_index "nodes", ["title"], :name => "index_nodes_on_title"
  add_index "nodes", ["uuid"], :name => "index_nodes_on_uuid", :unique => true

end
