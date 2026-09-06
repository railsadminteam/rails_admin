# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_09_21_171953) do
  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", default: "local", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "another_field_tests", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "balls", force: :cascade do |t|
    t.string "color"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "type"
  end

  create_table "categories", force: :cascade do |t|
    t.integer "parent_category_id"
  end

  create_table "cms_basic_pages", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer "commentable_id"
    t.string "commentable_type"
    t.text "content"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "custom_versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at", precision: nil
    t.index ["item_type", "item_id"], name: "index_custom_versions_on_item_type_and_item_id"
  end

  create_table "deeply_nested_field_tests", force: :cascade do |t|
    t.integer "nested_field_test_id"
    t.string "title"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["nested_field_test_id"], name: "index_deeply_nested_field_tests_on_nested_field_test_id"
  end

  create_table "divisions", primary_key: "custom_id", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "custom_league_id"
    t.string "name", limit: 50, null: false
  end

  create_table "drafts", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "player_id"
    t.integer "team_id"
    t.date "date"
    t.integer "round"
    t.integer "pick"
    t.integer "overall"
    t.string "college", limit: 100
    t.text "notes"
  end

  create_table "fans", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "name", limit: 100, null: false
  end

  create_table "fans_teams", id: false, force: :cascade do |t|
    t.integer "fan_id"
    t.integer "team_id"
    t.date "since"
  end

  create_table "favorite_players", primary_key: ["fan_id", "team_id", "player_id"], force: :cascade do |t|
    t.integer "fan_id", null: false
    t.integer "team_id", null: false
    t.integer "player_id", null: false
    t.string "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "field_tests", force: :cascade do |t|
    t.string "string_field"
    t.text "text_field"
    t.integer "integer_field"
    t.float "float_field"
    t.decimal "decimal_field"
    t.datetime "datetime_field", precision: nil
    t.datetime "timestamp_field", precision: nil
    t.time "time_field"
    t.date "date_field"
    t.boolean "boolean_field"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "format"
    t.string "restricted_field"
    t.string "protected_field"
    t.string "paperclip_asset_file_name"
    t.string "dragonfly_asset_uid"
    t.string "carrierwave_asset"
    t.string "dragonfly_asset_name"
    t.string "refile_asset_id"
    t.string "refile_asset_filename"
    t.string "refile_asset_size"
    t.string "refile_asset_content_type"
    t.string "string_enum_field"
    t.integer "integer_enum_field"
    t.string "carrierwave_assets"
    t.text "shrine_asset_data"
    t.text "shrine_versioning_asset_data"
    t.boolean "open"
    t.boolean "non_nullable_boolean_field", default: false, null: false
  end

  create_table "foo_bars", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "images", force: :cascade do |t|
    t.string "file_file_name"
    t.string "file_content_type"
    t.bigint "file_file_size"
    t.datetime "file_updated_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "leagues", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "name", limit: 50, null: false
  end

  create_table "nested_field_tests", force: :cascade do |t|
    t.string "title"
    t.integer "field_test_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "another_field_test_id"
  end

  create_table "paper_trail_tests", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "players", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.integer "team_id"
    t.string "name", limit: 100, null: false
    t.string "position", limit: 50
    t.integer "number", null: false
    t.boolean "retired", default: false
    t.boolean "injured", default: false
    t.date "born_on"
    t.text "notes"
    t.boolean "suspended", default: false
    t.string "formation", default: "substitute", null: false
  end

  create_table "rails_admin_histories", force: :cascade do |t|
    t.text "message"
    t.string "username"
    t.integer "item"
    t.string "table"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["item", "table"], name: "index_rails_admin_histories_on_item_and_table"
  end

  create_table "teams", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "division_id"
    t.string "name", limit: 50
    t.string "logo_url", limit: 255
    t.string "manager", limit: 100, null: false
    t.string "ballpark", limit: 100
    t.string "mascot", limit: 100
    t.integer "founded"
    t.integer "wins"
    t.integer "losses"
    t.float "win_percentage"
    t.decimal "revenue", precision: 18, scale: 2
    t.string "color"
    t.string "custom_field"
    t.integer "main_sponsor", default: 0, null: false
  end

  create_table "two_level_namespaced_polymorphic_association_tests", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "password_salt"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at", precision: nil
    t.string "roles"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at", precision: nil
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end
end
