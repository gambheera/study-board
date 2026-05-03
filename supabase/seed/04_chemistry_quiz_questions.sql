INSERT INTO quiz_questions
  (id, lesson_id, question_text, option_a, option_b, option_c, option_d, correct_option, order_index)
VALUES
  -- Topic 01: Atomic Structure (theory lesson)
  ('chem-q-atomic-01', 'chem-lesson-atomic-01',
   'The number of protons in an atom is equal to its:',
   'Mass number', 'Atomic number', 'Neutron number', 'Number of electron shells',
   'b', 1),

  -- Topic 02: Chemical Bonding
  ('chem-q-bonding-01', 'chem-lesson-bonding-01',
   'Which type of bond is formed by the electrostatic attraction between oppositely charged ions?',
   'Covalent bond', 'Metallic bond', 'Ionic bond', 'Hydrogen bond',
   'c', 1),

  -- Topic 03: Stoichiometry
  ('chem-q-stoich-01', 'chem-lesson-stoich-01',
   'How many moles of oxygen are required to completely combust 2 moles of methane (CH₄)?',
   '2 mol', '4 mol', '6 mol', '8 mol',
   'b', 1),

  -- Topic 04: States of Matter
  ('chem-q-states-01', 'chem-lesson-states-01',
   'Which gas law states that the volume of a fixed mass of gas is inversely proportional to its pressure at constant temperature?',
   'Charles'' Law', 'Boyle''s Law', 'Avogadro''s Law', 'Gay-Lussac''s Law',
   'b', 1),

  -- Topic 05: Thermodynamics
  ('chem-q-thermo-01', 'chem-lesson-thermo-01',
   'A reaction with ΔH < 0 and ΔS > 0 is:',
   'Always non-spontaneous', 'Spontaneous only at high temperatures', 'Always spontaneous', 'Non-spontaneous at all temperatures',
   'c', 1),

  -- Topic 06: Chemical Equilibrium
  ('chem-q-equil-01', 'chem-lesson-equil-01',
   'According to Le Chatelier''s Principle, increasing the pressure on a gaseous equilibrium mixture will shift the equilibrium towards:',
   'The side with more moles of gas', 'The side with fewer moles of gas', 'The right side always', 'No change',
   'b', 1),

  -- Topic 07: Chemical Kinetics
  ('chem-q-kinetics-01', 'chem-lesson-kinetics-01',
   'A catalyst increases the rate of a reaction by:',
   'Increasing the temperature', 'Lowering the activation energy', 'Increasing reactant concentrations', 'Shifting the equilibrium',
   'b', 1),

  -- Topic 08: Acids, Bases and Salts
  ('chem-q-acids-01', 'chem-lesson-acids-01',
   'What is the pH of a solution with [H⁺] = 1 × 10⁻³ mol/dm³?',
   '3', '11', '7', '−3',
   'a', 1),

  -- Topic 09: Electrochemistry
  ('chem-q-electro-01', 'chem-lesson-electro-01',
   'In an electrochemical cell, oxidation occurs at the:',
   'Cathode', 'Anode', 'Salt bridge', 'Electrolyte',
   'b', 1),

  -- Topic 10: s-Block Elements
  ('chem-q-sblock-01', 'chem-lesson-sblock-01',
   'Which Group 1 metal reacts most vigorously with water?',
   'Lithium', 'Sodium', 'Potassium', 'Caesium',
   'd', 1),

  -- Topic 11: p-Block Elements
  ('chem-q-pblock-01', 'chem-lesson-pblock-01',
   'Which halogen is the most reactive?',
   'Iodine', 'Bromine', 'Chlorine', 'Fluorine',
   'd', 1),

  -- Topic 12: d-Block Elements
  ('chem-q-dblock-01', 'chem-lesson-dblock-01',
   'Which property is characteristic of transition metals?',
   'Fixed oxidation states only', 'No catalytic activity', 'Variable oxidation states', 'No coloured ions',
   'c', 1),

  -- Topic 13: Organic Chemistry Introduction
  ('chem-q-org-intro-01', 'chem-lesson-org-intro-01',
   'Which type of isomerism involves compounds with the same molecular formula but different functional groups?',
   'Chain isomerism', 'Positional isomerism', 'Functional group isomerism', 'Geometric isomerism',
   'c', 1),

  -- Topic 14: Hydrocarbons
  ('chem-q-hydro-01', 'chem-lesson-hydro-01',
   'What type of reaction do alkenes primarily undergo?',
   'Free radical substitution', 'Electrophilic addition', 'Nucleophilic substitution', 'Electrophilic substitution',
   'b', 1),

  -- Topic 15: Haloalkanes
  ('chem-q-halo-01', 'chem-lesson-halo-01',
   'Which haloalkane is most reactive in nucleophilic substitution?',
   'Chloroethane', 'Bromoethane', 'Fluoroethane', 'Iodoethane',
   'd', 1),

  -- Topic 16: Alcohols and Phenols
  ('chem-q-alco-01', 'chem-lesson-alco-01',
   'What is the product when a primary alcohol is oxidised with acidified K₂Cr₂O₇ (excess)?',
   'An aldehyde', 'A ketone', 'A carboxylic acid', 'An ester',
   'c', 1),

  -- Topic 17: Carbonyl Compounds
  ('chem-q-carbonyl-01', 'chem-lesson-carbonyl-01',
   'Which reagent distinguishes aldehydes from ketones in Tollens'' test?',
   'Acidified K₂Cr₂O₇', 'Ammoniacal silver nitrate solution', '2,4-DNPH', 'Bromine water',
   'b', 1),

  -- Topic 18: Carboxylic Acids and Derivatives
  ('chem-q-carbox-01', 'chem-lesson-carbox-01',
   'In the esterification of ethanoic acid with ethanol, the catalyst used is:',
   'NaOH', 'Concentrated H₂SO₄', 'HCl gas', 'Anhydrous AlCl₃',
   'b', 1),

  -- Topic 19: Amines
  ('chem-q-amines-01', 'chem-lesson-amines-01',
   'Amines are basic because the nitrogen atom:',
   'Has a positive charge', 'Has a lone pair of electrons', 'Is bonded to hydrogen', 'Contains a π bond',
   'b', 1),

  -- Topic 20: Polymers and Biomolecules
  ('chem-q-poly-01', 'chem-lesson-poly-01',
   'Which type of polymerisation involves the loss of a small molecule such as water?',
   'Addition polymerisation', 'Free radical polymerisation', 'Condensation polymerisation', 'Ionic polymerisation',
   'c', 1)

ON CONFLICT (id) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  option_a = EXCLUDED.option_a,
  option_b = EXCLUDED.option_b,
  option_c = EXCLUDED.option_c,
  option_d = EXCLUDED.option_d,
  correct_option = EXCLUDED.correct_option,
  order_index = EXCLUDED.order_index;
