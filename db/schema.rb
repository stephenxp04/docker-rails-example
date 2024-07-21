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

ActiveRecord::Schema[7.1].define(version: 4) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clicks", force: :cascade do |t|
    t.bigint "short_url_id", null: false
    t.string "geolocation"
    t.datetime "clicked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["short_url_id"], name: "index_clicks_on_short_url_id"
  end

  create_table "short_urls", force: :cascade do |t|
    t.bigint "url_id", null: false
    t.string "short_url", limit: 15, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["short_url"], name: "index_short_urls_on_short_url", unique: true
    t.index ["url_id"], name: "index_short_urls_on_url_id"
  end

  create_table "urls", force: :cascade do |t|
    t.string "target_url"
    t.string "title"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_urls_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "cookie", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cookie"], name: "index_users_on_cookie", unique: true
  end

  add_foreign_key "clicks", "short_urls"
  add_foreign_key "short_urls", "urls"
  add_foreign_key "urls", "users"
end
