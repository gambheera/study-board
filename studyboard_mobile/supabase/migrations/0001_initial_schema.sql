-- =============================================================================
-- StudyBoard: Initial Supabase Schema
-- Migration: 0001_initial_schema.sql
-- Mirrors Drift schema (Story 1.3) exactly.
-- All student data tables have RLS enforcing student_id = auth.uid().
-- Content tables are public SELECT (authenticated), no write.
-- Soft-delete: students SELECT policy includes AND deleted_at IS NULL.
-- =============================================================================

-- ---------------------------------------------------------------------------
-- REFERENCE TABLES (server-seeded; INTEGER PK safe — not compared to auth.uid())
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS past_paper_question_types (
  id INTEGER NOT NULL PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(50) NOT NULL UNIQUE   -- 'MCQ' | 'Structured' | 'Essay' | etc.
);

CREATE TABLE IF NOT EXISTS schools (
  id INTEGER NOT NULL PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(255) NOT NULL,
  district VARCHAR(100) NOT NULL,
  UNIQUE(name, district)
);

-- ---------------------------------------------------------------------------
-- CONTENT TABLES (public read, no student scope)
-- Client-generated TEXT UUIDs — must match Drift schema for offline-first sync.
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS subjects (
  id TEXT NOT NULL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  quiz_pass_threshold DOUBLE PRECISION NOT NULL DEFAULT 0.8,
  content_version INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS topics (
  id TEXT NOT NULL PRIMARY KEY,
  subject_id TEXT NOT NULL,
  title VARCHAR(255) NOT NULL,
  order_index INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS lessons (
  id TEXT NOT NULL PRIMARY KEY,
  topic_id TEXT NOT NULL,
  title VARCHAR(255) NOT NULL,
  content_text TEXT NOT NULL,
  content_track VARCHAR(50) NOT NULL,   -- 'theory' | 'past_papers' | 'future_papers'
  order_index INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS quiz_questions (
  id TEXT NOT NULL PRIMARY KEY,
  lesson_id TEXT NOT NULL,
  question_text TEXT NOT NULL,
  option_a TEXT NOT NULL,
  option_b TEXT NOT NULL,
  option_c TEXT NOT NULL,
  option_d TEXT NOT NULL,
  correct_option VARCHAR(1) NOT NULL,   -- 'a' | 'b' | 'c' | 'd'
  order_index INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS past_paper_questions (
  id TEXT NOT NULL PRIMARY KEY,
  lesson_id TEXT NOT NULL,
  topic_id TEXT NOT NULL,
  question_type_id INTEGER,             -- FK → past_paper_question_types.id
  question_text TEXT NOT NULL,
  year INTEGER,
  order_index INTEGER NOT NULL DEFAULT 0
);

-- ---------------------------------------------------------------------------
-- STUDENT DATA TABLES (scoped to auth.uid())
-- students.id and all student_id columns MUST be UUID to match auth.uid().
-- Other IDs (lesson_id etc.) remain TEXT to match Drift offline-first UUIDs.
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS students (
  id UUID NOT NULL PRIMARY KEY DEFAULT auth.uid(),
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE
    CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
  district VARCHAR(100) NOT NULL,
  school_id INTEGER NOT NULL REFERENCES schools(id),
  fcm_token VARCHAR(255),
  notifications_enabled BOOLEAN NOT NULL DEFAULT TRUE,
  deactivated_at TEXT,
  deleted_at TEXT,
  last_active_at TEXT NOT NULL,
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS lesson_tasks (
  id TEXT NOT NULL PRIMARY KEY,
  student_id UUID NOT NULL,
  lesson_id TEXT NOT NULL,
  task_status VARCHAR(50) NOT NULL DEFAULT 'backlog'
    CHECK (task_status IN ('backlog', 'todo', 'in_progress', 'done')),
  curiosity_completed BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  UNIQUE (student_id, lesson_id)
);

CREATE TABLE IF NOT EXISTS quiz_attempts (
  id TEXT NOT NULL PRIMARY KEY,
  student_id UUID NOT NULL,
  lesson_id TEXT NOT NULL,
  score DOUBLE PRECISION NOT NULL,
  passed BOOLEAN NOT NULL,
  attempted_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS sessions (
  id TEXT NOT NULL PRIMARY KEY,
  student_id UUID NOT NULL,
  started_at TEXT NOT NULL,
  ended_at TEXT,
  attributed_nudge_id TEXT             -- logical FK → nudge_events.id; nullable
);

CREATE TABLE IF NOT EXISTS survey_responses (
  id TEXT NOT NULL PRIMARY KEY,
  student_id UUID NOT NULL,
  responses TEXT NOT NULL,             -- JSON payload
  responded_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS nudge_events (
  id TEXT NOT NULL PRIMARY KEY,
  student_id UUID NOT NULL,
  sent_at TEXT NOT NULL,
  fcm_message_id VARCHAR(255),
  status VARCHAR(50) NOT NULL          -- 'sent' | 'delivered' | 'failed'
);

-- ---------------------------------------------------------------------------
-- SYNC TABLES (client-written; student-scoped)
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS sync_queue (
  id TEXT NOT NULL PRIMARY KEY,
  student_id UUID NOT NULL,            -- for RLS scoping
  entity_type VARCHAR(100) NOT NULL,
  entity_id TEXT NOT NULL,
  operation VARCHAR(50) NOT NULL,      -- 'upsert' | 'soft_delete'
  payload TEXT NOT NULL,
  created_at TEXT NOT NULL,
  retry_count INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS sync_error_log (
  id TEXT NOT NULL PRIMARY KEY,
  student_id UUID NOT NULL,            -- for RLS scoping
  entity_type VARCHAR(100) NOT NULL,
  entity_id TEXT NOT NULL,
  operation VARCHAR(50) NOT NULL,
  payload TEXT NOT NULL,
  error_message TEXT NOT NULL,
  failed_at TEXT NOT NULL,
  retry_count INTEGER NOT NULL DEFAULT 0
);

-- ---------------------------------------------------------------------------
-- INDEXES (performance)
-- ---------------------------------------------------------------------------

CREATE INDEX IF NOT EXISTS idx_topics_subject_id          ON topics (subject_id);
CREATE INDEX IF NOT EXISTS idx_lessons_topic_id           ON lessons (topic_id);
CREATE INDEX IF NOT EXISTS idx_lesson_tasks_student_id    ON lesson_tasks (student_id);
CREATE INDEX IF NOT EXISTS idx_lesson_tasks_lesson_id     ON lesson_tasks (lesson_id);
CREATE INDEX IF NOT EXISTS idx_quiz_questions_lesson_id   ON quiz_questions (lesson_id);
CREATE INDEX IF NOT EXISTS idx_quiz_attempts_student_id   ON quiz_attempts (student_id);
CREATE INDEX IF NOT EXISTS idx_quiz_attempts_lesson_id    ON quiz_attempts (lesson_id);
CREATE INDEX IF NOT EXISTS idx_sessions_student_id        ON sessions (student_id);
CREATE INDEX IF NOT EXISTS idx_nudge_events_student_id    ON nudge_events (student_id);
CREATE INDEX IF NOT EXISTS idx_past_paper_questions_lesson_id ON past_paper_questions (lesson_id);
CREATE INDEX IF NOT EXISTS idx_sync_queue_student_id      ON sync_queue (student_id);

-- ---------------------------------------------------------------------------
-- ENABLE ROW LEVEL SECURITY
-- ---------------------------------------------------------------------------

ALTER TABLE past_paper_question_types  ENABLE ROW LEVEL SECURITY;
ALTER TABLE schools                    ENABLE ROW LEVEL SECURITY;

ALTER TABLE subjects                   ENABLE ROW LEVEL SECURITY;
ALTER TABLE topics                     ENABLE ROW LEVEL SECURITY;
ALTER TABLE lessons                    ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_questions             ENABLE ROW LEVEL SECURITY;
ALTER TABLE past_paper_questions       ENABLE ROW LEVEL SECURITY;

ALTER TABLE students                   ENABLE ROW LEVEL SECURITY;
ALTER TABLE lesson_tasks               ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_attempts              ENABLE ROW LEVEL SECURITY;
ALTER TABLE sessions                   ENABLE ROW LEVEL SECURITY;
ALTER TABLE survey_responses           ENABLE ROW LEVEL SECURITY;
ALTER TABLE nudge_events               ENABLE ROW LEVEL SECURITY;
ALTER TABLE sync_queue                 ENABLE ROW LEVEL SECURITY;
ALTER TABLE sync_error_log             ENABLE ROW LEVEL SECURITY;

-- ---------------------------------------------------------------------------
-- RLS POLICIES: REFERENCE TABLES (public SELECT, no write)
-- ---------------------------------------------------------------------------

CREATE POLICY "past_paper_question_types_select_authenticated"
  ON past_paper_question_types FOR SELECT TO authenticated USING (true);

CREATE POLICY "schools_select_authenticated"
  ON schools FOR SELECT TO authenticated USING (true);

-- ---------------------------------------------------------------------------
-- RLS POLICIES: CONTENT TABLES (public SELECT, no write)
-- ---------------------------------------------------------------------------

CREATE POLICY "subjects_select_authenticated"
  ON subjects FOR SELECT TO authenticated USING (true);

CREATE POLICY "topics_select_authenticated"
  ON topics FOR SELECT TO authenticated USING (true);

CREATE POLICY "lessons_select_authenticated"
  ON lessons FOR SELECT TO authenticated USING (true);

CREATE POLICY "quiz_questions_select_authenticated"
  ON quiz_questions FOR SELECT TO authenticated USING (true);

CREATE POLICY "past_paper_questions_select_authenticated"
  ON past_paper_questions FOR SELECT TO authenticated USING (true);

-- ---------------------------------------------------------------------------
-- RLS POLICIES: STUDENTS TABLE
-- ---------------------------------------------------------------------------
-- SELECT: own row only; soft-deleted rows are invisible (deleted_at IS NULL).
-- INSERT/UPDATE/DELETE: own row only; no deleted_at filter on write side.

CREATE POLICY "students_select_own"
  ON students FOR SELECT TO authenticated
  USING (id = auth.uid() AND deleted_at IS NULL);

CREATE POLICY "students_insert_own"
  ON students FOR INSERT TO authenticated
  WITH CHECK (id = auth.uid());

CREATE POLICY "students_update_own"
  ON students FOR UPDATE TO authenticated
  USING (id = auth.uid())
  WITH CHECK (id = auth.uid());

CREATE POLICY "students_delete_own"
  ON students FOR DELETE TO authenticated
  USING (id = auth.uid());

-- ---------------------------------------------------------------------------
-- RLS POLICIES: LESSON_TASKS
-- ---------------------------------------------------------------------------

CREATE POLICY "lesson_tasks_own"
  ON lesson_tasks FOR ALL TO authenticated
  USING (student_id = auth.uid())
  WITH CHECK (student_id = auth.uid());

-- ---------------------------------------------------------------------------
-- RLS POLICIES: QUIZ_ATTEMPTS
-- ---------------------------------------------------------------------------

CREATE POLICY "quiz_attempts_own"
  ON quiz_attempts FOR ALL TO authenticated
  USING (student_id = auth.uid())
  WITH CHECK (student_id = auth.uid());

-- ---------------------------------------------------------------------------
-- RLS POLICIES: SESSIONS
-- ---------------------------------------------------------------------------

CREATE POLICY "sessions_own"
  ON sessions FOR ALL TO authenticated
  USING (student_id = auth.uid())
  WITH CHECK (student_id = auth.uid());

-- ---------------------------------------------------------------------------
-- RLS POLICIES: SURVEY_RESPONSES
-- ---------------------------------------------------------------------------

CREATE POLICY "survey_responses_own"
  ON survey_responses FOR ALL TO authenticated
  USING (student_id = auth.uid())
  WITH CHECK (student_id = auth.uid());

-- ---------------------------------------------------------------------------
-- RLS POLICIES: NUDGE_EVENTS
-- ---------------------------------------------------------------------------
-- Students can read their own nudge events (for attribution).
-- INSERT is server-side only (Edge Function with service role) — no client INSERT policy.

CREATE POLICY "nudge_events_select_own"
  ON nudge_events FOR SELECT TO authenticated
  USING (student_id = auth.uid());

-- ---------------------------------------------------------------------------
-- RLS POLICIES: SYNC_QUEUE + SYNC_ERROR_LOG
-- ---------------------------------------------------------------------------

CREATE POLICY "sync_queue_own"
  ON sync_queue FOR ALL TO authenticated
  USING (student_id = auth.uid())
  WITH CHECK (student_id = auth.uid());

CREATE POLICY "sync_error_log_own"
  ON sync_error_log FOR ALL TO authenticated
  USING (student_id = auth.uid())
  WITH CHECK (student_id = auth.uid());
