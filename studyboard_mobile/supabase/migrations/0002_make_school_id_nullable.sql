-- =============================================================================
-- StudyBoard: Make school_id nullable on students
-- Migration: 0002_make_school_id_nullable.sql
--
-- Why: Registration (Story 1.6) creates the student row before onboarding.
-- The student selects their school during onboarding (Story 1.9), so
-- school_id must be nullable at insert time.
-- =============================================================================

ALTER TABLE students ALTER COLUMN school_id DROP NOT NULL;
