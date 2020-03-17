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

ActiveRecord::Schema.define(version: 2020_02_26_202435) do

  create_table "action_mailbox_inbound_emails", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
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
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "arts", force: :cascade do |t|
    t.integer "user_id"
    t.string "unique_token"
    t.string "element_id"
    t.integer "art_id"
    t.float "x_pos"
    t.float "y_pos"
    t.string "shape"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "post_id"
    t.integer "comment_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "anon_token"
    t.string "image"
    t.integer "bot_id"
    t.integer "proposal_id"
    t.integer "vote_id"
    t.integer "like_id"
    t.integer "note_id"
    t.integer "shared_item_id"
    t.integer "item_library_id"
    t.integer "survey_id"
  end

  create_table "connections", force: :cascade do |t|
    t.integer "user_id"
    t.integer "other_user_id"
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "invite"
    t.boolean "request"
    t.string "anon_token"
    t.string "unique_token"
    t.boolean "redeemed"
    t.boolean "grant_dev_access"
    t.boolean "message_folder"
    t.integer "connection_id"
    t.integer "total_messages_seen"
    t.boolean "grant_mod_access"
    t.string "invite_password"
    t.boolean "portal"
    t.integer "total_items_seen"
    t.datetime "last_typing_at"
    t.boolean "mod"
    t.boolean "admin"
    t.string "title"
  end

  create_table "crono_jobs", force: :cascade do |t|
    t.string "job_id", null: false
    t.text "log", limit: 1073741823
    t.datetime "last_performed_at"
    t.boolean "healthy"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_crono_jobs_on_job_id", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.string "image"
    t.integer "user_id"
    t.datetime "start_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "anon_token"
    t.string "image"
    t.integer "user_id"
    t.string "unique_token"
    t.boolean "open"
    t.string "passphrase"
    t.boolean "pass_protected"
    t.integer "ratification_threshold"
    t.integer "view_limit"
    t.datetime "expires_at"
    t.boolean "hidden"
    t.string "social_structure"
    t.integer "total_items_seen"
  end

  create_table "item_categories", force: :cascade do |t|
    t.integer "item_library_id"
    t.integer "user_id"
    t.string "name"
    t.string "body"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "item_libraries", force: :cascade do |t|
    t.string "name"
    t.text "body"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "unique_token"
    t.integer "user_id"
  end

  create_table "item_requests", force: :cascade do |t|
    t.integer "user_id"
    t.integer "shared_item_id"
    t.string "unique_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "accepted", default: false
    t.datetime "expires_at"
    t.integer "chosen_days_to_borrow"
    t.text "body"
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id"
    t.string "anon_token"
    t.integer "post_id"
    t.integer "comment_id"
    t.string "unique_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "proposal_id"
    t.integer "vote_id"
    t.integer "like_id"
    t.integer "liked_user_id"
    t.boolean "love"
    t.boolean "whoa"
    t.boolean "hype"
    t.integer "shared_item_id"
    t.integer "survey_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "user_id"
    t.integer "receiver_id"
    t.integer "group_id"
    t.text "body"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "anon_token"
    t.string "receiver_token"
    t.integer "connection_id"
    t.string "sender_token"
    t.string "salt"
    t.string "unique_token"
  end

  create_table "notes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "sender_id"
    t.string "message"
    t.string "action"
    t.boolean "seen"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "anon_token"
    t.string "sender_token"
    t.integer "item_id"
    t.string "item_token"
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer "resource_owner_id", null: false
    t.integer "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["resource_owner_id"], name: "index_oauth_access_grants_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer "resource_owner_id"
    t.integer "application_id", null: false
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "pictures", force: :cascade do |t|
    t.integer "post_id"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "classifier_name"
    t.integer "order"
    t.integer "proposal_id"
    t.integer "user_id"
    t.boolean "reverted_back_to"
    t.integer "shared_item_id"
    t.integer "item_library_id"
    t.integer "survey_id"
  end

  create_table "portals", force: :cascade do |t|
    t.string "unique_token"
    t.datetime "expires_at"
    t.integer "remaining_uses"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "cluster"
    t.integer "cluster_id"
    t.integer "creator_id"
    t.integer "user_id"
    t.boolean "mod"
    t.boolean "dev"
    t.boolean "admin"
    t.boolean "expired"
    t.boolean "to_anrcho"
    t.boolean "to_dsa"
  end

  create_table "posts", force: :cascade do |t|
    t.integer "user_id"
    t.text "body"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "anon_token"
    t.integer "group_id"
    t.integer "original_id"
    t.boolean "hidden"
    t.boolean "photoset"
    t.string "unique_token"
    t.boolean "un_invited"
    t.string "video"
    t.boolean "sound"
    t.string "audio"
    t.string "audio_name"
    t.boolean "featured"
    t.boolean "social_maya_only"
    t.boolean "blog"
    t.string "title"
  end

  create_table "proposals", force: :cascade do |t|
    t.string "unique_token"
    t.string "anon_token"
    t.string "group_token"
    t.integer "group_id"
    t.integer "proposal_id"
    t.string "title"
    t.text "body"
    t.string "image"
    t.string "action"
    t.string "revised_action"
    t.boolean "ratified"
    t.boolean "requires_revision"
    t.boolean "revised"
    t.integer "version"
    t.integer "ratification_point"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "misc_data"
    t.integer "user_id"
    t.string "voting_type"
    t.boolean "anrcho_only"
  end

  create_table "settings", force: :cascade do |t|
    t.integer "user_id"
    t.integer "group_id"
    t.string "name"
    t.boolean "on"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shared_items", force: :cascade do |t|
    t.string "name"
    t.text "body"
    t.string "item_type"
    t.string "domain"
    t.string "size"
    t.string "aka"
    t.string "arrangement"
    t.string "contact"
    t.string "region"
    t.string "in_stock"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.integer "item_library_id"
    t.string "unique_token"
    t.string "video"
    t.boolean "photoset"
    t.integer "user_id"
    t.integer "item_category_id"
    t.integer "holder_id"
    t.integer "days_to_borrow"
  end

  create_table "simple_captcha_data", force: :cascade do |t|
    t.string "key", limit: 40
    t.string "value", limit: 6
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["key"], name: "idx_key"
  end

  create_table "sounds", force: :cascade do |t|
    t.integer "user_id"
    t.integer "group_id"
    t.string "name"
    t.string "audio"
    t.string "unique_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "post_id"
  end

  create_table "survey_answers", force: :cascade do |t|
    t.integer "survey_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "survey_result_id"
    t.text "question_body"
    t.integer "survey_question_id"
    t.boolean "other"
  end

  create_table "survey_questions", force: :cascade do |t|
    t.integer "survey_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "question_type", default: "open_ended"
    t.boolean "grid"
  end

  create_table "survey_results", force: :cascade do |t|
    t.integer "survey_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "survey_selections", force: :cascade do |t|
    t.integer "survey_question_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "row"
    t.integer "survey_selection_id"
    t.boolean "other"
  end

  create_table "surveys", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.text "body"
    t.string "image"
    t.integer "user_id"
    t.text "questions"
    t.integer "group_id"
    t.string "unique_token"
  end

  create_table "tags", force: :cascade do |t|
    t.integer "user_id"
    t.integer "post_id"
    t.integer "group_id"
    t.integer "comment_id"
    t.string "tag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "anon_token"
    t.integer "index"
    t.integer "proposal_id"
    t.integer "vote_id"
    t.integer "message_id"
    t.integer "shared_item_id"
    t.integer "item_library_id"
    t.integer "survey_id"
  end

  create_table "tests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "passphrase"
    t.binary "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "auth_token"
    t.string "image"
    t.text "body"
    t.string "email"
    t.string "password"
    t.string "password_salt"
    t.string "unique_token"
    t.boolean "dev"
    t.boolean "mod"
    t.integer "xp"
    t.datetime "last_active_at"
    t.boolean "hidden"
    t.string "title"
    t.boolean "guest"
    t.string "zodiac"
    t.integer "energy_points"
    t.string "geo_coordinates"
    t.string "location"
    t.boolean "featured"
    t.boolean "admin"
    t.boolean "dsa_member"
    t.string "phone_number"
  end

  create_table "views", force: :cascade do |t|
    t.integer "user_id"
    t.string "anon_token"
    t.integer "group_id"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "comment_id"
    t.integer "profile_id"
    t.string "ip_address"
    t.integer "proposal_id"
    t.integer "message_id"
    t.string "locale"
    t.integer "vote_id"
    t.integer "score_count"
    t.boolean "non_visible"
    t.boolean "click"
    t.integer "x_pos"
    t.integer "y_pos"
    t.integer "screen_width"
    t.integer "screen_height"
    t.integer "avail_screen_width"
    t.integer "avail_screen_height"
    t.integer "device_pixel_ratio"
    t.string "controller_name"
    t.string "action_name"
    t.string "current_url"
    t.integer "shared_item_id"
    t.integer "item_library_id"
    t.integer "survey_id"
  end

  create_table "votes", force: :cascade do |t|
    t.integer "proposal_id"
    t.integer "comment_id"
    t.integer "vote_id"
    t.string "unique_token"
    t.string "anon_token"
    t.text "body"
    t.string "flip_state"
    t.boolean "verified"
    t.integer "proposal_version"
    t.boolean "moot"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "bot_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_grants", "users", column: "resource_owner_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "users", column: "resource_owner_id"
end
