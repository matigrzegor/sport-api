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

ActiveRecord::Schema.define(version: 2020_03_17_072118) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answer_notification_data", force: :cascade do |t|
    t.bigint "user_id"
    t.string "time_tags", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_answer_notification_data_on_user_id"
  end

  create_table "athlete_platforms", force: :cascade do |t|
    t.string "athlete_name", null: false
    t.string "athlete_phone_number"
    t.string "athlete_email"
    t.string "athlete_sport_discipline"
    t.string "athlete_age"
    t.string "athlete_height"
    t.string "athlete_weight"
    t.string "athlete_arm"
    t.string "athlete_chest"
    t.string "athlete_waist"
    t.string "athlete_hips"
    t.string "athlete_tigh"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "fitness_level"
  end

  create_table "board_notes", force: :cascade do |t|
    t.string "board_note_name", null: false
    t.string "board_note_link"
    t.text "board_note_description"
    t.string "boardable_type"
    t.bigint "boardable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boardable_type", "boardable_id"], name: "index_board_notes_on_boardable_type_and_boardable_id"
  end

  create_table "calendar_assocs", force: :cascade do |t|
    t.bigint "tile_id"
    t.bigint "training_plan_id"
    t.string "calendar_date", null: false
    t.string "tile_color", null: false
    t.integer "training_sesion", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "asso_index_in_array", null: false
    t.index ["tile_id"], name: "index_calendar_assocs_on_tile_id"
    t.index ["training_plan_id"], name: "index_calendar_assocs_on_training_plan_id"
  end

  create_table "calendar_comments", force: :cascade do |t|
    t.bigint "training_plan_id"
    t.string "comment_user", null: false
    t.string "comment_data", null: false
    t.text "comment_body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "comment_day", null: false
    t.string "comment_user_role", null: false
    t.index ["training_plan_id"], name: "index_calendar_comments_on_training_plan_id"
  end

  create_table "calendar_stars", force: :cascade do |t|
    t.bigint "training_plan_id"
    t.string "star_color", null: false
    t.text "star_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "star_date", null: false
    t.index ["training_plan_id"], name: "index_calendar_stars_on_training_plan_id"
  end

  create_table "custom_athlete_parameters", force: :cascade do |t|
    t.bigint "athlete_platform_id"
    t.string "parameter_name", null: false
    t.string "parameter_date", null: false
    t.text "parameter_description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["athlete_platform_id"], name: "index_custom_athlete_parameters_on_athlete_platform_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.bigint "athlete_platform_id"
    t.string "platform_token", null: false
    t.string "recipient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["athlete_platform_id"], name: "index_invitations_on_athlete_platform_id"
    t.index ["platform_token"], name: "index_invitations_on_platform_token"
    t.index ["recipient_id"], name: "index_invitations_on_recipient_id"
  end

  create_table "marketplace_goods", force: :cascade do |t|
    t.string "good_id", null: false
    t.string "good_database_model", null: false
    t.string "good_creator", null: false
    t.string "good_status", null: false
    t.string "good_description"
    t.text "good_content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "athlete_platform_id"
    t.integer "membership_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["athlete_platform_id"], name: "index_memberships_on_athlete_platform_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "pending_user_invitations", force: :cascade do |t|
    t.bigint "athlete_platform_id"
    t.string "athlete_identifier", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["athlete_platform_id"], name: "index_pending_user_invitations_on_athlete_platform_id"
  end

  create_table "plan_appends", force: :cascade do |t|
    t.bigint "training_plan_id"
    t.bigint "athlete_platform_id"
    t.integer "plan_activity_status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "training_plan_name", null: false
    t.index ["athlete_platform_id"], name: "index_plan_appends_on_athlete_platform_id"
    t.index ["training_plan_id"], name: "index_plan_appends_on_training_plan_id"
  end

  create_table "platform_chats", force: :cascade do |t|
    t.bigint "athlete_platform_id"
    t.string "trainer_auth_sub", null: false
    t.string "athlete_auth_sub", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "athlete_username"
    t.string "trainer_username"
    t.string "athlete_avatar"
    t.string "trainer_avatar"
    t.index ["athlete_auth_sub"], name: "index_platform_chats_on_athlete_auth_sub"
    t.index ["athlete_platform_id"], name: "index_platform_chats_on_athlete_platform_id"
    t.index ["trainer_auth_sub"], name: "index_platform_chats_on_trainer_auth_sub"
  end

  create_table "platform_messages", force: :cascade do |t|
    t.bigint "platform_chat_id"
    t.string "user_auth_sub", null: false
    t.string "message_date", null: false
    t.text "message_text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "message_read", null: false
    t.index ["platform_chat_id"], name: "index_platform_messages_on_platform_chat_id"
  end

  create_table "platform_notes", force: :cascade do |t|
    t.bigint "athlete_platform_id"
    t.string "platform_note_name", null: false
    t.string "platform_note_link"
    t.text "platform_note_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["athlete_platform_id"], name: "index_platform_notes_on_athlete_platform_id"
  end

  create_table "question_answer_metadata", force: :cascade do |t|
    t.integer "training_sesion", null: false
    t.string "calendar_date", null: false
    t.integer "tile_id", null: false
    t.boolean "question_answered", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "calendar_assoc_id"
    t.bigint "training_plan_id"
    t.index ["calendar_assoc_id"], name: "index_question_answer_metadata_on_calendar_assoc_id"
    t.index ["training_plan_id"], name: "index_question_answer_metadata_on_training_plan_id"
  end

  create_table "question_answers", force: :cascade do |t|
    t.bigint "training_plan_id"
    t.string "question_date", null: false
    t.string "question_answer"
    t.text "answer_comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tile_id"
    t.index ["tile_id"], name: "index_question_answers_on_tile_id"
    t.index ["training_plan_id"], name: "index_question_answers_on_training_plan_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id"
    t.bigint "tile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["tile_id"], name: "index_taggings_on_tile_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "tag_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "tile_activities", force: :cascade do |t|
    t.string "tile_activity_name"
    t.integer "tile_activity_reps"
    t.string "tile_activity_unit"
    t.string "tile_activity_amount"
    t.string "tile_activity_intensity"
    t.string "tile_activity_intensity_amount"
    t.string "tile_activity_rest_unit"
    t.string "tile_activity_rest_amount"
    t.text "tile_activity_note"
    t.bigint "tile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tile_activity_rest_intensity"
    t.string "tile_activity_rest_intensity_amount"
    t.string "tile_activity_rest_after_activity_unit"
    t.string "tile_activity_rest_after_activity_amount"
    t.string "tile_activity_rest_after_activity_intensity"
    t.string "tile_activity_rest_after_activity_intensity_amount"
    t.index ["tile_id"], name: "index_tile_activities_on_tile_id"
  end

  create_table "tile_diet_nutrients", force: :cascade do |t|
    t.string "tile_diet_nutrient_name"
    t.string "tile_diet_nutrient_unit"
    t.string "tile_diet_nutrient_amount"
    t.bigint "tile_diet_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tile_diet_id"], name: "index_tile_diet_nutrients_on_tile_diet_id"
  end

  create_table "tile_diets", force: :cascade do |t|
    t.string "tile_diet_meal"
    t.string "tile_diet_energy_unit"
    t.string "tile_diet_energy_amount"
    t.string "tile_diet_carbohydrates_unit"
    t.string "tile_diet_carbohydrates_amount"
    t.string "tile_diet_protein_unit"
    t.string "tile_diet_protein_amount"
    t.string "tile_diet_fat_unit"
    t.string "string"
    t.string "tile_diet_fat_amount"
    t.text "tile_diet_note"
    t.bigint "tile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tile_id"], name: "index_tile_diets_on_tile_id"
  end

  create_table "tile_motivations", force: :cascade do |t|
    t.string "tile_motivation_sentence"
    t.string "tile_motivation_link"
    t.bigint "tile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tile_id"], name: "index_tile_motivations_on_tile_id"
  end

  create_table "tile_questions", force: :cascade do |t|
    t.string "tile_ask_question"
    t.boolean "tile_answer_numeric"
    t.integer "tile_answer_numeric_from"
    t.integer "tile_answer_numeric_to"
    t.bigint "tile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "tile_answers_descriptives"
    t.index ["tile_id"], name: "index_tile_questions_on_tile_id"
  end

  create_table "tiles", force: :cascade do |t|
    t.string "tile_type", null: false
    t.string "tile_type_name", null: false
    t.string "tile_type_color", null: false
    t.string "tile_title", null: false
    t.text "tile_description"
    t.integer "tile_activities_sets", default: 1
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tile_activities_sets_rest_unit"
    t.string "tile_activities_sets_rest_amount"
    t.string "tile_activities_sets_rest_intensity_unit"
    t.string "tile_activities_sets_rest_intensity_amount"
    t.index ["user_id"], name: "index_tiles_on_user_id"
  end

  create_table "training_plans", force: :cascade do |t|
    t.string "training_plan_name", null: false
    t.string "date_from", null: false
    t.string "date_to", null: false
    t.integer "training_sesion_number", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["training_plan_name"], name: "index_training_plans_on_training_plan_name"
    t.index ["user_id"], name: "index_training_plans_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "auth_sub", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stripe_customer_id"
    t.integer "account_level"
    t.integer "current_paid_access_start_date"
    t.integer "current_paid_access_end_date"
    t.integer "paid_access_start_date"
    t.integer "trial_start_date"
    t.integer "trial_end_date"
    t.index ["auth_sub"], name: "index_users_on_auth_sub", unique: true
  end

  add_foreign_key "answer_notification_data", "users"
  add_foreign_key "calendar_assocs", "tiles"
  add_foreign_key "calendar_assocs", "training_plans"
  add_foreign_key "calendar_comments", "training_plans"
  add_foreign_key "calendar_stars", "training_plans"
  add_foreign_key "custom_athlete_parameters", "athlete_platforms"
  add_foreign_key "invitations", "athlete_platforms"
  add_foreign_key "memberships", "athlete_platforms"
  add_foreign_key "memberships", "users"
  add_foreign_key "pending_user_invitations", "athlete_platforms"
  add_foreign_key "plan_appends", "athlete_platforms"
  add_foreign_key "plan_appends", "training_plans"
  add_foreign_key "platform_messages", "platform_chats"
  add_foreign_key "platform_notes", "athlete_platforms"
  add_foreign_key "question_answers", "training_plans"
  add_foreign_key "taggings", "tags"
  add_foreign_key "taggings", "tiles"
  add_foreign_key "tile_activities", "tiles"
  add_foreign_key "tile_diet_nutrients", "tile_diets"
  add_foreign_key "tile_diets", "tiles"
  add_foreign_key "tile_motivations", "tiles"
  add_foreign_key "tile_questions", "tiles"
  add_foreign_key "tiles", "users"
  add_foreign_key "training_plans", "users"
end
