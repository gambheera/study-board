-- =============================================================================
-- StudyBoard: Auto-create student profile on auth signup
-- Migration: 0003_student_profile_trigger.sql
--
-- Why: The client-side INSERT into students after signUp() is blocked by RLS
-- because the session is not yet propagated when the PostgREST call fires.
-- Running this as SECURITY DEFINER bypasses RLS safely on the server side.
-- =============================================================================

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = public
AS $$
BEGIN
  INSERT INTO public.students (
    id, name, email, district, school_id,
    notifications_enabled, last_active_at, created_at
  )
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'name', ''),
    NEW.email,
    '',
    NULL,
    TRUE,
    NOW(),
    NOW()
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
