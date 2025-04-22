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

ActiveRecord::Schema[8.0].define(version: 2025_04_22_131443) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "cooking_recipes", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.jsonb "steps"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "foods", force: :cascade do |t|
    t.string "label"
    t.jsonb "nutrition_facts"
    t.string "source"
    t.string "source_code"
    t.string "source_label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source", "source_code"], name: "index_foods_on_source_and_source_code", unique: true
  end

  create_table "ingredients", primary_key: ["cooking_recipe_id", "food_id"], force: :cascade do |t|
    t.bigint "cooking_recipe_id", null: false
    t.bigint "food_id", null: false
    t.decimal "quantity", precision: 5, scale: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cooking_recipe_id"], name: "index_ingredients_on_cooking_recipe_id"
    t.index ["food_id"], name: "index_ingredients_on_food_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "gender"
    t.date "birthdate"
    t.integer "height_in_centimeters"
    t.integer "weight_in_grams"
    t.string "activity_level"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "profile", default: "basic", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end
end
