INSERT INTO subjects (id, name, quiz_pass_threshold, content_version)
VALUES (
  'chem-subject-001',
  'A/L Chemistry',
  0.8,
  1
)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  quiz_pass_threshold = EXCLUDED.quiz_pass_threshold,
  content_version = EXCLUDED.content_version;
