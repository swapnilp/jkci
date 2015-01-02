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

ActiveRecord::Schema.define(version: 20150102170951) do

  create_table "batches", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "std",        limit: 255
    t.string   "year",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_active",  limit: 1,   default: true
  end

  create_table "chapters", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "subject_id", limit: 4
    t.integer  "chapt_no",   limit: 4
    t.integer  "std",        limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "class_catlogs", force: :cascade do |t|
    t.integer  "student_id",              limit: 4
    t.integer  "jkci_class_id",           limit: 4
    t.integer  "daily_teaching_point_id", limit: 4
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_present",              limit: 1, default: false
    t.boolean  "is_recover",              limit: 1, default: false
    t.date     "recover_date"
    t.boolean  "sms_sent",                limit: 1, default: false
    t.boolean  "is_followed",             limit: 1, default: false
  end

  create_table "class_students", force: :cascade do |t|
    t.integer  "jkci_class_id", limit: 4
    t.integer  "student_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "daily_teaching_points", force: :cascade do |t|
    t.datetime "date"
    t.text     "points",         limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "jkci_class_id",  limit: 4
    t.integer  "teacher_id",     limit: 4
    t.boolean  "is_fill_catlog", limit: 1,     default: false
    t.boolean  "is_sms_sent",    limit: 1,     default: false
    t.integer  "chapter_id",     limit: 4
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.boolean  "is_single_day", limit: 1,   default: true
    t.date     "start_date"
    t.date     "end_date"
    t.string   "time",          limit: 255
    t.string   "description",   limit: 255
    t.string   "location",      limit: 255
    t.string   "conductor",     limit: 255
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "exam_absents", force: :cascade do |t|
    t.integer  "student_id",  limit: 4
    t.integer  "exam_id",     limit: 4
    t.boolean  "sms_sent",    limit: 1
    t.boolean  "email_sent",  limit: 1
    t.boolean  "reattend",    limit: 1
    t.datetime "attend_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exam_catlogs", force: :cascade do |t|
    t.integer  "exam_id",       limit: 4
    t.integer  "student_id",    limit: 4
    t.integer  "jkci_class_id", limit: 4
    t.float    "marks",         limit: 24
    t.boolean  "is_present",    limit: 1
    t.boolean  "is_recover",    limit: 1,     default: false
    t.date     "recover_date"
    t.text     "remark",        limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_followed",   limit: 1,     default: false
  end

  create_table "exam_results", force: :cascade do |t|
    t.integer  "student_id",  limit: 4
    t.integer  "exam_id",     limit: 4
    t.float    "marks",       limit: 24
    t.boolean  "sms_sent",    limit: 1
    t.boolean  "email_sent",  limit: 1
    t.boolean  "late_attend", limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exams", force: :cascade do |t|
    t.integer  "subject_id",            limit: 4
    t.string   "conducted_by",          limit: 255
    t.integer  "marks",                 limit: 4
    t.datetime "exam_date"
    t.float    "duration",              limit: 24
    t.string   "exam_type",             limit: 255
    t.integer  "std",                   limit: 4
    t.string   "remark",                limit: 255
    t.boolean  "is_result_decleared",   limit: 1
    t.boolean  "is_completed",          limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                  limit: 255
    t.boolean  "is_active",             limit: 1,   default: true
    t.integer  "jkci_class_id",         limit: 4
    t.string   "class_ids",             limit: 255
    t.string   "daily_teaching_points", limit: 255
  end

  create_table "jkci_classes", force: :cascade do |t|
    t.string   "class_name",       limit: 255
    t.datetime "class_start_time"
    t.datetime "class_end_time"
    t.integer  "teacher_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "batch_id",         limit: 4
    t.boolean  "is_active",        limit: 1,   default: true
    t.integer  "subject_id",       limit: 4
  end

  create_table "sms_sents", force: :cascade do |t|
    t.text     "number",     limit: 65535
    t.string   "obj_type",   limit: 255
    t.integer  "obj_id",     limit: 4
    t.text     "message",    limit: 65535
    t.boolean  "is_parent",  limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", force: :cascade do |t|
    t.string   "first_name",  limit: 255
    t.string   "last_name",   limit: 255
    t.string   "email",       limit: 255
    t.string   "mobile",      limit: 255
    t.string   "parent_name", limit: 255
    t.string   "p_mobile",    limit: 255
    t.string   "p_email",     limit: 255
    t.text     "address",     limit: 65535
    t.string   "group",       limit: 255
    t.string   "rank",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "std",         limit: 4
    t.boolean  "is_active",   limit: 1,     default: true
    t.string   "middle_name", limit: 255
  end

  create_table "subjects", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teachers", force: :cascade do |t|
    t.integer  "subject_id", limit: 4
    t.string   "first_name", limit: 255
    t.string   "last_name",  limit: 255
    t.string   "mobile",     limit: 255
    t.string   "email",      limit: 255
    t.text     "address",    limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
