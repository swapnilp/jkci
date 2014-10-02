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

ActiveRecord::Schema.define(version: 20141002080929) do

  create_table "class_catlogs", force: true do |t|
    t.integer  "student_id"
    t.integer  "jkci_class_id"
    t.integer  "daily_teaching_point_id"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "class_students", force: true do |t|
    t.integer  "jkci_class_id"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "daily_teaching_points", force: true do |t|
    t.datetime "date"
    t.text     "points"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "jkci_class_id"
    t.integer  "teacher_id"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "exam_absents", force: true do |t|
    t.integer  "student_id"
    t.integer  "exam_id"
    t.boolean  "sms_sent"
    t.boolean  "email_sent"
    t.boolean  "reattend"
    t.datetime "attend_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exam_results", force: true do |t|
    t.integer  "student_id"
    t.integer  "exam_id"
    t.float    "marks"
    t.boolean  "sms_sent"
    t.boolean  "email_sent"
    t.boolean  "late_attend"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exams", force: true do |t|
    t.integer  "subject_id"
    t.string   "conducted_by"
    t.integer  "marks"
    t.datetime "exam_date"
    t.float    "duration"
    t.string   "exam_type"
    t.integer  "std"
    t.string   "remark"
    t.boolean  "is_result_decleared"
    t.boolean  "is_completed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.boolean  "is_active",           default: true
    t.integer  "jkci_class_id"
  end

  create_table "jkci_classes", force: true do |t|
    t.string   "class_name"
    t.datetime "class_start_time"
    t.datetime "class_end_time"
    t.integer  "teacher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "mobile"
    t.string   "parent_name"
    t.string   "p_mobile"
    t.string   "p_email"
    t.text     "address"
    t.string   "group"
    t.string   "rank"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "std"
    t.boolean  "is_active",   default: true
    t.string   "middle_name"
  end

  create_table "subjects", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teachers", force: true do |t|
    t.integer  "subject_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "mobile"
    t.string   "email"
    t.text     "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
