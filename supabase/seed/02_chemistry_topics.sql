INSERT INTO topics (id, subject_id, title, order_index)
VALUES
  ('chem-topic-01', 'chem-subject-001', 'Atomic Structure', 1),
  ('chem-topic-02', 'chem-subject-001', 'Chemical Bonding', 2),
  ('chem-topic-03', 'chem-subject-001', 'Stoichiometry', 3),
  ('chem-topic-04', 'chem-subject-001', 'States of Matter', 4),
  ('chem-topic-05', 'chem-subject-001', 'Thermodynamics and Energetics', 5),
  ('chem-topic-06', 'chem-subject-001', 'Chemical Equilibrium', 6),
  ('chem-topic-07', 'chem-subject-001', 'Chemical Kinetics', 7),
  ('chem-topic-08', 'chem-subject-001', 'Acids, Bases and Salts', 8),
  ('chem-topic-09', 'chem-subject-001', 'Electrochemistry', 9),
  ('chem-topic-10', 'chem-subject-001', 'Chemistry of s-Block Elements', 10),
  ('chem-topic-11', 'chem-subject-001', 'Chemistry of p-Block Elements', 11),
  ('chem-topic-12', 'chem-subject-001', 'Chemistry of d-Block Elements', 12),
  ('chem-topic-13', 'chem-subject-001', 'Organic Chemistry — Introduction', 13),
  ('chem-topic-14', 'chem-subject-001', 'Hydrocarbons', 14),
  ('chem-topic-15', 'chem-subject-001', 'Haloalkanes', 15),
  ('chem-topic-16', 'chem-subject-001', 'Alcohols and Phenols', 16),
  ('chem-topic-17', 'chem-subject-001', 'Carbonyl Compounds', 17),
  ('chem-topic-18', 'chem-subject-001', 'Carboxylic Acids and Derivatives', 18),
  ('chem-topic-19', 'chem-subject-001', 'Amines', 19),
  ('chem-topic-20', 'chem-subject-001', 'Polymers and Biomolecules', 20)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  order_index = EXCLUDED.order_index;
