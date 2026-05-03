INSERT INTO lessons (id, topic_id, title, content_text, content_track, order_index)
VALUES
  -- Topic 01: Atomic Structure
  ('chem-lesson-atomic-01', 'chem-topic-01',
   'Atomic Structure — Theory',
   'The atom consists of a nucleus containing protons and neutrons, surrounded by electrons in shells. The atomic number equals the number of protons. Electrons occupy energy levels (shells) described by quantum numbers. The electronic configuration determines chemical properties. Isotopes have the same atomic number but different mass numbers. Relative atomic mass accounts for isotope abundance.',
   'theory', 1),
  ('chem-lesson-atomic-02', 'chem-topic-01',
   'Atomic Structure — Past Papers',
   'Past paper questions on atomic structure from A/L Chemistry examinations. Topics include electron configuration, isotopes, ionisation energy, and the structure of the atom.',
   'past_papers', 2),

  -- Topic 02: Chemical Bonding
  ('chem-lesson-bonding-01', 'chem-topic-02',
   'Chemical Bonding — Theory',
   'Chemical bonds form when atoms share or transfer electrons to achieve stable electron configurations. Ionic bonds involve electron transfer between metals and non-metals. Covalent bonds involve electron sharing between non-metals. The electronegativity difference determines bond polarity. VSEPR theory predicts molecular geometry based on electron pair repulsion. Metallic bonding involves delocalised electrons in a lattice.',
   'theory', 1),
  ('chem-lesson-bonding-02', 'chem-topic-02',
   'Chemical Bonding — Past Papers',
   'Past paper questions on chemical bonding, including ionic, covalent, and metallic bonds, VSEPR theory, bond polarity, and molecular geometry.',
   'past_papers', 2),

  -- Topic 03: Stoichiometry
  ('chem-lesson-stoich-01', 'chem-topic-03',
   'Stoichiometry — Theory',
   'Stoichiometry is the quantitative relationship between reactants and products in chemical reactions. The mole concept (Avogadro''s number: 6.022 × 10²³) links mass to number of particles. Molar mass is the mass of one mole of a substance in g/mol. Balanced equations give mole ratios. Limiting reagent determines the maximum product. Percentage yield = (actual yield / theoretical yield) × 100.',
   'theory', 1),
  ('chem-lesson-stoich-02', 'chem-topic-03',
   'Stoichiometry — Past Papers',
   'Past paper questions on stoichiometry, mole calculations, limiting reagents, percentage yield, and empirical/molecular formula determination.',
   'past_papers', 2),

  -- Topic 04: States of Matter
  ('chem-lesson-states-01', 'chem-topic-04',
   'States of Matter — Theory',
   'Matter exists as solid, liquid, or gas depending on temperature and pressure. Solids have fixed shape and volume; liquids have fixed volume but take the shape of their container; gases fill their container. The kinetic molecular theory explains the behaviour of gases. Ideal gas law: PV = nRT. Intermolecular forces (van der Waals, dipole-dipole, hydrogen bonding) determine physical properties.',
   'theory', 1),
  ('chem-lesson-states-02', 'chem-topic-04',
   'States of Matter — Past Papers',
   'Past paper questions on states of matter, the ideal gas law, kinetic molecular theory, and intermolecular forces.',
   'past_papers', 2),

  -- Topic 05: Thermodynamics and Energetics
  ('chem-lesson-thermo-01', 'chem-topic-05',
   'Thermodynamics and Energetics — Theory',
   'Thermodynamics studies energy changes in chemical reactions. Enthalpy (ΔH) measures heat change at constant pressure. Exothermic reactions release heat (ΔH < 0); endothermic reactions absorb heat (ΔH > 0). Hess''s Law: enthalpy change is path-independent. Standard enthalpy of formation, combustion, and neutralisation. Entropy (ΔS) measures disorder. Gibbs free energy: ΔG = ΔH − TΔS; spontaneous when ΔG < 0.',
   'theory', 1),
  ('chem-lesson-thermo-02', 'chem-topic-05',
   'Thermodynamics and Energetics — Past Papers',
   'Past paper questions on enthalpy, Hess''s Law, entropy, Gibbs free energy, and energy cycles.',
   'past_papers', 2),

  -- Topic 06: Chemical Equilibrium
  ('chem-lesson-equil-01', 'chem-topic-06',
   'Chemical Equilibrium — Theory',
   'Chemical equilibrium occurs when forward and reverse reaction rates are equal, and concentrations remain constant. The equilibrium constant Kc is expressed in terms of molar concentrations. Le Chatelier''s Principle: a system at equilibrium responds to disturbances by shifting to minimise the change. Effects of concentration, pressure, temperature, and catalysts on equilibrium position. Kp relates to partial pressures of gases.',
   'theory', 1),
  ('chem-lesson-equil-02', 'chem-topic-06',
   'Chemical Equilibrium — Past Papers',
   'Past paper questions on equilibrium constants, Le Chatelier''s Principle, the Haber process, and equilibrium calculations.',
   'past_papers', 2),

  -- Topic 07: Chemical Kinetics
  ('chem-lesson-kinetics-01', 'chem-topic-07',
   'Chemical Kinetics — Theory',
   'Chemical kinetics studies reaction rates and the factors that affect them. Rate of reaction = change in concentration / time. Factors: concentration, temperature, surface area, catalysts. Rate law: rate = k[A]^m[B]^n. Reaction order is determined experimentally. Activation energy (Ea) is the minimum energy for a reaction. The Arrhenius equation: k = Ae^(−Ea/RT). Catalysts lower activation energy without being consumed.',
   'theory', 1),
  ('chem-lesson-kinetics-02', 'chem-topic-07',
   'Chemical Kinetics — Past Papers',
   'Past paper questions on reaction rates, rate laws, activation energy, the Arrhenius equation, and catalysis.',
   'past_papers', 2),

  -- Topic 08: Acids, Bases and Salts
  ('chem-lesson-acids-01', 'chem-topic-08',
   'Acids, Bases and Salts — Theory',
   'Arrhenius acids produce H⁺; bases produce OH⁻. Brønsted-Lowry: acids are proton donors, bases are proton acceptors. Lewis acids accept electron pairs; Lewis bases donate electron pairs. pH = −log[H⁺]. Strong acids/bases fully dissociate; weak acids/bases partially dissociate. Ka and Kb measure acid/base strength. Buffer solutions resist pH change. Salt hydrolysis determines if a salt solution is acidic, basic, or neutral.',
   'theory', 1),
  ('chem-lesson-acids-02', 'chem-topic-08',
   'Acids, Bases and Salts — Past Papers',
   'Past paper questions on acid-base theories, pH calculations, buffer solutions, Ka/Kb, and salt hydrolysis.',
   'past_papers', 2),

  -- Topic 09: Electrochemistry
  ('chem-lesson-electro-01', 'chem-topic-09',
   'Electrochemistry — Theory',
   'Electrochemistry studies the relationship between chemical reactions and electrical energy. Oxidation involves loss of electrons; reduction involves gain of electrons (OIL RIG). Standard electrode potential (E°) measures tendency to be reduced. Electrochemical cells convert chemical energy to electrical energy. Electrolysis uses electrical energy to drive non-spontaneous reactions. Faraday''s laws of electrolysis relate charge to mass of product.',
   'theory', 1),
  ('chem-lesson-electro-02', 'chem-topic-09',
   'Electrochemistry — Past Papers',
   'Past paper questions on redox reactions, electrode potentials, electrochemical cells, and electrolysis calculations.',
   'past_papers', 2),

  -- Topic 10: Chemistry of s-Block Elements
  ('chem-lesson-sblock-01', 'chem-topic-10',
   'Chemistry of s-Block Elements — Theory',
   'Group 1 (alkali metals) and Group 2 (alkaline earth metals) form the s-block. They have low ionisation energies and are highly reactive. Group 1 elements react vigorously with water to form hydroxides and hydrogen. Group 2 elements are less reactive but form oxides, hydroxides, and carbonates. Flame test colours identify s-block metals. Thermal stability of carbonates and nitrates increases down the group.',
   'theory', 1),
  ('chem-lesson-sblock-02', 'chem-topic-10',
   'Chemistry of s-Block Elements — Past Papers',
   'Past paper questions on the properties and reactions of Group 1 and Group 2 elements and their compounds.',
   'past_papers', 2),

  -- Topic 11: Chemistry of p-Block Elements
  ('chem-lesson-pblock-01', 'chem-topic-11',
   'Chemistry of p-Block Elements — Theory',
   'The p-block spans Groups 13–18. Properties vary widely from metals to non-metals and noble gases. Key topics: the halogens (Group 17) — reactivity decreases down the group; nitrogen and its oxides; sulphur compounds; chlorine chemistry; reactions of Period 3 oxides with water. Diagonal relationships exist between some p-block elements.',
   'theory', 1),
  ('chem-lesson-pblock-02', 'chem-topic-11',
   'Chemistry of p-Block Elements — Past Papers',
   'Past paper questions on the properties, reactions, and compounds of p-block elements including halogens, nitrogen, and sulphur.',
   'past_papers', 2),

  -- Topic 12: Chemistry of d-Block Elements
  ('chem-lesson-dblock-01', 'chem-topic-12',
   'Chemistry of d-Block Elements — Theory',
   'Transition metals (d-block) have partially filled d-orbitals. Characteristic properties: variable oxidation states, coloured ions, formation of complex ions, catalytic activity. Crystal field theory explains colour and magnetism. Common complexes: [Cu(H₂O)₆]²⁺, [Fe(CN)₆]³⁻. Ligands are Lewis bases that donate electron pairs to the metal centre. The spectrochemical series ranks ligands by field strength.',
   'theory', 1),
  ('chem-lesson-dblock-02', 'chem-topic-12',
   'Chemistry of d-Block Elements — Past Papers',
   'Past paper questions on transition metal chemistry, complex ions, oxidation states, and catalysis.',
   'past_papers', 2),

  -- Topic 13: Organic Chemistry — Introduction
  ('chem-lesson-org-intro-01', 'chem-topic-13',
   'Organic Chemistry — Introduction — Theory',
   'Organic chemistry studies carbon-containing compounds. Carbon forms four covalent bonds and can form chains, rings, and multiple bonds. Functional groups determine chemical behaviour. Homologous series share a general formula and show gradation in physical properties. IUPAC nomenclature provides systematic naming. Types of formulae: molecular, empirical, structural, displayed, skeletal. Isomerism: structural (chain, positional, functional group) and stereoisomerism.',
   'theory', 1),
  ('chem-lesson-org-intro-02', 'chem-topic-13',
   'Organic Chemistry — Introduction — Past Papers',
   'Past paper questions on organic nomenclature, functional groups, isomerism, and types of organic formulae.',
   'past_papers', 2),

  -- Topic 14: Hydrocarbons
  ('chem-lesson-hydro-01', 'chem-topic-14',
   'Hydrocarbons — Theory',
   'Hydrocarbons contain only carbon and hydrogen. Alkanes (CₙH₂ₙ₊₂): saturated, undergo free radical substitution. Alkenes (CₙH₂ₙ): unsaturated, undergo electrophilic addition. Alkynes (CₙH₂ₙ₋₂): contain triple bonds. Aromatic hydrocarbons (benzene ring): undergo electrophilic aromatic substitution. Markovnikov''s rule determines addition product orientation. Cracking of hydrocarbons produces smaller molecules.',
   'theory', 1),
  ('chem-lesson-hydro-02', 'chem-topic-14',
   'Hydrocarbons — Past Papers',
   'Past paper questions on alkane, alkene, and benzene reactions including free radical substitution, electrophilic addition, and aromatic substitution.',
   'past_papers', 2),

  -- Topic 15: Haloalkanes
  ('chem-lesson-halo-01', 'chem-topic-15',
   'Haloalkanes — Theory',
   'Haloalkanes (alkyl halides) contain a halogen substituent on an alkane. They undergo nucleophilic substitution (SN1 and SN2) and elimination reactions. The C–X bond polarity makes carbon electrophilic. Reactivity order: RI > RBr > RCl > RF. Primary haloalkanes favour SN2; tertiary favour SN1 and elimination. Uses include refrigerants (CFCs) and solvents, but CFCs deplete the ozone layer.',
   'theory', 1),
  ('chem-lesson-halo-02', 'chem-topic-15',
   'Haloalkanes — Past Papers',
   'Past paper questions on nucleophilic substitution, elimination reactions, and the reactivity of haloalkanes.',
   'past_papers', 2),

  -- Topic 16: Alcohols and Phenols
  ('chem-lesson-alco-01', 'chem-topic-16',
   'Alcohols and Phenols — Theory',
   'Alcohols contain the –OH group. Primary, secondary, and tertiary alcohols differ in the number of carbon substituents on the carbon bearing –OH. Reactions: oxidation (primary → aldehyde → carboxylic acid; secondary → ketone), dehydration to alkenes, esterification with carboxylic acids. Phenols are more acidic than alcohols due to resonance stabilisation of the phenoxide ion. Phenol undergoes electrophilic aromatic substitution readily.',
   'theory', 1),
  ('chem-lesson-alco-02', 'chem-topic-16',
   'Alcohols and Phenols — Past Papers',
   'Past paper questions on alcohol oxidation, dehydration, esterification, and phenol reactions.',
   'past_papers', 2),

  -- Topic 17: Carbonyl Compounds
  ('chem-lesson-carbonyl-01', 'chem-topic-17',
   'Carbonyl Compounds — Theory',
   'Carbonyl compounds contain the C=O group. Aldehydes have the CHO group; ketones have C=O between two carbon groups. Reactions: nucleophilic addition (with HCN, NaBH₄, LiAlH₄), condensation with 2,4-DNPH (identification test). Tollens'' and Fehling''s tests distinguish aldehydes from ketones. Aldol condensation joins two carbonyl molecules. The carbonyl carbon is electrophilic due to the polar C=O bond.',
   'theory', 1),
  ('chem-lesson-carbonyl-02', 'chem-topic-17',
   'Carbonyl Compounds — Past Papers',
   'Past paper questions on aldehyde and ketone reactions, nucleophilic addition, and identification tests.',
   'past_papers', 2),

  -- Topic 18: Carboxylic Acids and Derivatives
  ('chem-lesson-carbox-01', 'chem-topic-18',
   'Carboxylic Acids and Derivatives — Theory',
   'Carboxylic acids (–COOH) are weak acids that form esters with alcohols (Fischer esterification). Derivatives include acid chlorides, anhydrides, esters, and amides. Nucleophilic acyl substitution is the key mechanism. Reactivity order: acid chlorides > anhydrides > esters > amides. Soaps are sodium salts of long-chain carboxylic acids. Amino acids contain both –COOH and –NH₂ groups and are amphoteric.',
   'theory', 1),
  ('chem-lesson-carbox-02', 'chem-topic-18',
   'Carboxylic Acids and Derivatives — Past Papers',
   'Past paper questions on esterification, hydrolysis, and the reactions of carboxylic acid derivatives.',
   'past_papers', 2),

  -- Topic 19: Amines
  ('chem-lesson-amines-01', 'chem-topic-19',
   'Amines — Theory',
   'Amines are derivatives of ammonia with nitrogen bearing one, two, or three organic groups (primary, secondary, tertiary). They are basic and nucleophilic due to the lone pair on nitrogen. Primary amines react with HNO₂ to form diazonium salts at 0–5°C; secondary amines form N-nitrosamines. Diazonium salts undergo coupling reactions to form azo dyes. Amines are prepared by reduction of nitro compounds or amides.',
   'theory', 1),
  ('chem-lesson-amines-02', 'chem-topic-19',
   'Amines — Past Papers',
   'Past paper questions on amine basicity, diazotisation, coupling reactions, and synthesis of amines.',
   'past_papers', 2),

  -- Topic 20: Polymers and Biomolecules
  ('chem-lesson-poly-01', 'chem-topic-20',
   'Polymers and Biomolecules — Theory',
   'Polymers are large molecules made of repeating monomer units. Addition polymers (e.g., polyethene, PVC) form from alkenes via free radical, cationic, or anionic mechanisms. Condensation polymers (e.g., nylon, polyester) form with loss of small molecules (water or HCl). Biomolecules: carbohydrates (monosaccharides, disaccharides, polysaccharides), proteins (amino acid polymers linked by peptide bonds), lipids (triglycerides, phospholipids), and nucleic acids (DNA, RNA).',
   'theory', 1),
  ('chem-lesson-poly-02', 'chem-topic-20',
   'Polymers and Biomolecules — Past Papers',
   'Past paper questions on addition and condensation polymerisation, carbohydrates, proteins, and lipids.',
   'past_papers', 2)

ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  content_text = EXCLUDED.content_text,
  content_track = EXCLUDED.content_track,
  order_index = EXCLUDED.order_index;
