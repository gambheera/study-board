INSERT INTO past_paper_questions
  (id, lesson_id, topic_id, question_text, year, order_index)
VALUES
  -- Topic 01: Atomic Structure (past_papers lesson)
  ('chem-pp-atomic-01', 'chem-lesson-atomic-02', 'chem-topic-01',
   'State and explain the trend in atomic radius across Period 3 of the Periodic Table.',
   2019, 1),

  -- Topic 02: Chemical Bonding
  ('chem-pp-bonding-01', 'chem-lesson-bonding-02', 'chem-topic-02',
   'Explain why the melting point of sodium chloride is much higher than that of hydrogen chloride.',
   2020, 1),

  -- Topic 03: Stoichiometry
  ('chem-pp-stoich-01', 'chem-lesson-stoich-02', 'chem-topic-03',
   'A 3.00 g sample of a metal carbonate MCO₃ was completely dissolved in excess hydrochloric acid. Calculate the molar mass of M if 0.0300 mol of CO₂ was produced.',
   2018, 1),

  -- Topic 04: States of Matter
  ('chem-pp-states-01', 'chem-lesson-states-02', 'chem-topic-04',
   'A gas occupies 500 cm³ at 27°C and 100 kPa. Calculate the volume of the gas at 127°C and 200 kPa.',
   2021, 1),

  -- Topic 05: Thermodynamics
  ('chem-pp-thermo-01', 'chem-lesson-thermo-02', 'chem-topic-05',
   'Using Hess''s Law and the given standard enthalpies of formation, calculate the standard enthalpy change for the combustion of ethanol (C₂H₅OH).',
   2019, 1),

  -- Topic 06: Chemical Equilibrium
  ('chem-pp-equil-01', 'chem-lesson-equil-02', 'chem-topic-06',
   'For the reaction N₂(g) + 3H₂(g) ⇌ 2NH₃(g), state and explain the effect of increasing pressure on the equilibrium yield of ammonia.',
   2022, 1),

  -- Topic 07: Chemical Kinetics
  ('chem-pp-kinetics-01', 'chem-lesson-kinetics-02', 'chem-topic-07',
   'Describe an experiment to show how the concentration of a reactant affects the rate of the reaction between sodium thiosulfate and hydrochloric acid.',
   2018, 1),

  -- Topic 08: Acids, Bases and Salts
  ('chem-pp-acids-01', 'chem-lesson-acids-02', 'chem-topic-08',
   'Calculate the pH of a buffer solution containing 0.10 mol/dm³ of ethanoic acid and 0.10 mol/dm³ of sodium ethanoate. (Ka of ethanoic acid = 1.8 × 10⁻⁵ mol/dm³)',
   2020, 1),

  -- Topic 09: Electrochemistry
  ('chem-pp-electro-01', 'chem-lesson-electro-02', 'chem-topic-09',
   'Calculate the mass of copper deposited at the cathode when a current of 2.00 A is passed through copper(II) sulfate solution for 30 minutes. (Mr of Cu = 63.5)',
   2021, 1),

  -- Topic 10: s-Block Elements
  ('chem-pp-sblock-01', 'chem-lesson-sblock-02', 'chem-topic-10',
   'Explain why the thermal stability of Group 2 carbonates increases down the group.',
   2019, 1),

  -- Topic 11: p-Block Elements
  ('chem-pp-pblock-01', 'chem-lesson-pblock-02', 'chem-topic-11',
   'Describe what you would observe when chlorine water is added to a solution of potassium bromide, and write the ionic equation for the reaction.',
   2022, 1),

  -- Topic 12: d-Block Elements
  ('chem-pp-dblock-01', 'chem-lesson-dblock-02', 'chem-topic-12',
   'Explain why transition metal ions are coloured, using an example to illustrate your answer.',
   2020, 1),

  -- Topic 13: Organic Chemistry Introduction
  ('chem-pp-org-intro-01', 'chem-lesson-org-intro-02', 'chem-topic-13',
   'Draw and name all the structural isomers of C₄H₁₀O that are primary alcohols.',
   2018, 1),

  -- Topic 14: Hydrocarbons
  ('chem-pp-hydro-01', 'chem-lesson-hydro-02', 'chem-topic-14',
   'Describe the mechanism for the free radical substitution of methane with chlorine to form chloromethane. Include the initiation, propagation, and termination steps.',
   2021, 1),

  -- Topic 15: Haloalkanes
  ('chem-pp-halo-01', 'chem-lesson-halo-02', 'chem-topic-15',
   'Outline the mechanism for the reaction of 2-bromopropane with aqueous sodium hydroxide. State the type of mechanism and identify the role of OH⁻.',
   2019, 1),

  -- Topic 16: Alcohols and Phenols
  ('chem-pp-alco-01', 'chem-lesson-alco-02', 'chem-topic-16',
   'Describe how you would distinguish between ethanol, phenol, and ethanoic acid using simple chemical tests. State the reagent and the expected observation for each.',
   2022, 1),

  -- Topic 17: Carbonyl Compounds
  ('chem-pp-carbonyl-01', 'chem-lesson-carbonyl-02', 'chem-topic-17',
   'Describe the mechanism for the nucleophilic addition of hydrogen cyanide to propanal. Show clearly the role of the CN⁻ ion.',
   2020, 1),

  -- Topic 18: Carboxylic Acids and Derivatives
  ('chem-pp-carbox-01', 'chem-lesson-carbox-02', 'chem-topic-18',
   'Write the equation for the reaction between ethanoic acid and ethanol in the presence of a concentrated sulfuric acid catalyst. Name the type of reaction and the organic product.',
   2018, 1),

  -- Topic 19: Amines
  ('chem-pp-amines-01', 'chem-lesson-amines-02', 'chem-topic-19',
   'Describe the preparation of a diazonium salt from phenylamine (aniline) and explain how it can be used to produce an azo dye.',
   2021, 1),

  -- Topic 20: Polymers and Biomolecules
  ('chem-pp-poly-01', 'chem-lesson-poly-02', 'chem-topic-20',
   'Draw a section of the condensation polymer formed from 6-aminohexanoic acid (H₂N(CH₂)₅COOH) and name the type of linkage formed.',
   2019, 1)

ON CONFLICT (id) DO UPDATE SET
  question_text = EXCLUDED.question_text,
  year = EXCLUDED.year,
  order_index = EXCLUDED.order_index;
