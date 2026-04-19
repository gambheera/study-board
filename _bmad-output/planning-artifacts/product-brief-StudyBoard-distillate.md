---
title: "Product Brief Distillate: StudyBoard"
type: llm-distillate
source: "product-brief-StudyBoard.md"
created: "2026-04-14"
purpose: "Token-efficient context for downstream PRD creation"
---

# StudyBoard — Detail Pack for PRD Creation

## Core Mental Model (Critical for PRD)

- **The A/L exam is a software project.** Student = product owner + developer. Syllabus = backlog.
- Board states: Backlog → To-Do → In Progress → Done (Agile/Kanban-style)
- "Done" is NOT self-reported — requires passing a quiz (Definition of Done). Fail = task re-opens.
- Three content tracks per subject: Theory, Past Papers, Future Papers
- Curiosity-first flow: student sees past paper questions BEFORE studying the lesson, not after
- This is a study *operating system*, not a content platform and not a simple task tracker

## Task Taxonomy

- **Lessons** = tasks (unit of theory content)
- **Sub-lessons** = child tasks under lessons
- **Past paper questions** = tasks (linked to their parent subtopic/lesson)
- **Future paper questions** = tasks (reserved infrastructure; content inserted separately)
- Each task has a status and belongs to a content track and a subject
- Tasks accumulate in a backlog spanning the student's full A/L journey

## Definition of Done — Detail

- Each lesson has a quiz of comprehensive questions
- Student must pass the quiz to mark lesson Done
- Fail = task re-opens (Not Done, not punished — just re-opened)
- Quiz questions are manually created content (same workflow as lesson content)
- This is the core trust mechanism — makes all dashboard metrics honest/verifiable

## Curiosity-First Pedagogy — Detail

- Before studying a lesson, the student is shown past paper questions from that topic
- Purpose: create "why?" in the mind before the lesson answers it
- Framed as a universal learning principle (not experimental) — knowledge that answers a question the brain has already asked is absorbed more deeply
- This is a deliberate UX flow, not an optional feature — it is the default lesson entry path

## Content Tracks — Detail

| Track | Description | Content Source |
|-------|-------------|----------------|
| Theory | Lessons and sub-lessons with notes, diagrams | Manual |
| Past Papers | Actual past exam questions, linked to subtopics | Manual |
| Future Papers | Predicted/guessed questions | Manual; separate workflow; infrastructure reserved in V1 |

- Content supports rich media: chemical formulas, molecular diagrams, charts, images
- All content lives in Supabase database — inserted manually after system is built
- Rich media requirement applies to both lesson notes and past paper question display

## Progress Dashboard — Detail

- Syllabus coverage % (topics/subtopics with Done status)
- Past paper completion % per topic
- Correct rate per topic (accuracy score)
- Weakest topics ranked (sorted by accuracy, ascending)
- Dashboard data is trustworthy BECAUSE of DoD enforcement — no self-reporting

## UX & Engagement Philosophy — Critical

- **Dopamine-driven**: every tap, click, animation must feel satisfying
- Engagement through delight, not stress
- Completing a task = visual reward
- Finishing a topic = unlocks next
- Streaks = momentum mechanic
- The UX IS the retention mechanism — this is not cosmetic, it is core to the product
- Students should feel engaged, not pressured
- Target: students use the app because it feels good, not just because they should

## Technical Context

- **Stack**: Flutter (mobile) + Supabase (backend/db)
- **Platform priority**: Android first
- **Connectivity**: Offline-first — significant % of users in low-connectivity areas (rural districts, commutes, weak mobile signal)
- **Device range**: Low-to-mid range Android devices in Sri Lanka — dopamine-driven animations must perform well on these devices (performance risk to address in architecture)
- **Data sync**: Offline actions (quiz completions, task status changes) must sync correctly when connectivity resumes

## Business Model — Deferred but Directionally Known

- V1 (test period): Completely free
- Post-validation tiers (rough direction, not finalized):
  - Free plan: basic features
  - Premium plan(s): more features
  - Top-tier "daily standup" plan: small cohort (≈5 students) + human scrum master-style coach on daily calls
- In-app content marketplace: lessons/materials purchasable; top-tier plan unlocks all content free
- Monetization details to be finalized after validation — do NOT scope for monetization in V1 build

## Daily Standup Plan — Detail (Future, Not V1)

- Small team format: ≈5 students per group
- A support person joins a daily call, plays scrum master role
- Measures progress, facilitates accountability
- This is a premium human-assisted service, not automated
- Relevant for future teacher/cohort features — out of V1

## User Segments — Detail

**V1 Primary: A/L Chemistry students**
- Age: 16–19
- Sri Lankan Advanced Level, Physical Science or Biological Science stream
- Attend tuition classes + school simultaneously
- Study evenings and weekends
- Android-native, mobile-first
- Many in low-connectivity areas
- Serious, high-pressure learners — not casual
- Do NOT need more content; need a system to execute what they already have

**Future (architecturally considered, not built in V1):**
- Parents: want visibility into child's progress
- Tuition class instructors: cohort monitoring, powerful distribution channel, content validation partners

## Distribution & GTM — Not V1 Scope but Noted

- Post-validation plan: Facebook ad campaigns
- Pre-validation: manual recruitment through personal contacts (test group sourced by founder)
- Teachers are the key distribution lever long-term (not explicitly in V1 but should inform architecture decisions around class/cohort features)
- Students already share materials via WhatsApp and Facebook study groups — shareable progress could drive organic word-of-mouth (future feature consideration)

## Scale Vision

- V1: Chemistry, small test group, Sri Lanka
- Near-term: All A/L subjects (Physics, Biology, Economics, etc.)
- Medium-term: O/L subjects
- Long-term: Professional certifications, competitive entrance exams
- Geographic expansion beyond Sri Lanka possible
- Architecture must support multi-subject from day one even if V1 only loads Chemistry data

## Rejected / Out of Scope for V1 (Do Not Re-propose)

- AI-powered study recommendations (natural future feature but not V1)
- Parent-facing features (architecturally considered but not built)
- Teacher/instructor dashboard (same)
- Peer leaderboards or social features (future engagement layer)
- Automated quiz generation (all quizzes are manually created)
- Multiple language support (English-medium assumed for V1)
- Web platform (mobile-first; web is not the target)

## Open Questions Resolved During Discovery

- Quiz creation: manual process, same workflow as lesson content
- Future papers: infrastructure reserved in V1; data inserted via separate workflow later
- Test group recruitment: founder has direct contacts; not a product concern
- Curiosity-first pedagogy: framed as universal learning principle, not hypothesis to validate
