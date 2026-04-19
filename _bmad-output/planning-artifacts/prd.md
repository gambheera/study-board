---
stepsCompleted: ["step-01-init", "step-02-discovery", "step-02b-vision", "step-02c-executive-summary", "step-03-success", "step-04-journeys", "step-05-domain", "step-06-innovation", "step-07-project-type", "step-08-scoping", "step-09-functional", "step-10-nonfunctional", "step-11-polish", "step-12-complete"]
workflowStatus: complete
completedAt: "2026-04-15"
inputDocuments:
  - "_bmad-output/planning-artifacts/product-brief-StudyBoard.md"
  - "_bmad-output/planning-artifacts/product-brief-StudyBoard-distillate.md"
briefCount: 2
researchCount: 0
brainstormingCount: 0
projectDocsCount: 0
classification:
  projectType: mobile_app
  domain: edtech
  complexity: medium
  projectContext: greenfield
workflowType: 'prd'
---

# Product Requirements Document - StudyBoard

**Author:** Lahiru
**Date:** 2026-04-14

## Executive Summary

StudyBoard is a mobile-first study operating system for Sri Lankan A/L students, built on Flutter (Android-first) with a Supabase backend. Version 1 targets A/L Chemistry — approximately 300,000 candidates per year face an exam where the bottleneck is not content availability but execution discipline. StudyBoard converts the entire Chemistry syllabus into an Agile-style task board (Backlog → To-Do → In Progress → Done) where every metric is trustworthy because completion is enforced, not self-reported. A student cannot mark a lesson Done without passing its comprehensive quiz; fail the quiz, the task re-opens.

The core emotional outcome is calm, structured confidence: a student opens the app and knows exactly where they stand, what to do next, and how far they've come. Study anxiety — "am I doing enough?" — is replaced by a bird's-eye view of a completable plan. Haptic feedback, visual rewards, and streak mechanics make task completion feel satisfying rather than stressful, driving intrinsic motivation and daily return.

Target users are A/L Chemistry students aged 16–19, attending tuition classes and school simultaneously, studying on low-to-mid range Android devices, often in low-connectivity areas. They are not casual learners; they are high-pressure students who already have access to content and need a system to execute it.

### What Makes This Special

Four bets no competitor in the Sri Lankan A/L market has made simultaneously:

1. **Enforced Definition of Done.** Quiz passage is required to mark a lesson complete. This single mechanism makes every dashboard number honest — coverage percentages, topic accuracy rates, and weakest-topic rankings are all verifiable signals, not vanity metrics.

2. **Curiosity-first pedagogy.** Before studying a lesson, students encounter past paper questions from that topic. Knowledge that answers a question the brain has already asked is absorbed more deeply than knowledge delivered unprompted. This is a deliberate, default UX flow — not an option.

3. **Dopamine-driven UX as retention infrastructure.** Haptic feedback on task completion, visual rewards, streaks, and animated transitions are not cosmetic — they are the engagement mechanism. Students return because completing things feels rewarding, not because they feel obligated.

4. **Self-directed learning as a structural bet.** The traditional Sri Lankan study cycle (class → notes → past papers at year-end) is passive and reactive. StudyBoard is built on the conviction that self-directed learning is the future of education — positioning students to own their preparation process entirely.

The differentiation moment: a student finishes a topic, feels the haptic response, watches the task slide to Done, and knows it is real because they passed the quiz. That trust mechanism — verified progress rather than claimed progress — is what separates StudyBoard from every other study tool in this market.

## Project Classification

- **Project Type:** Mobile application (Flutter, cross-platform; Android-first)
- **Domain:** EdTech — A/L exam preparation, Sri Lanka
- **Complexity:** Medium (offline-first sync, rich media content, enforced state machine logic; no regulatory compliance requirements in V1)
- **Project Context:** Greenfield — no existing system; building from scratch
- **Backend:** Supabase (Postgres + auth + storage)
- **Platform Priority:** Android-first; iOS architecturally supported via Flutter but not the V1 distribution target

## Success Criteria

### User Success

- **Engagement:** ≥3 study sessions per week per student in the V1 test group, tracked automatically by the app. (Rationale: V1 covers Chemistry only — daily use is not expected when a student has multiple subjects to manage across school and tuition.)
- **Syllabus coverage:** Configurable per subject coverage threshold; Chemistry V1 target is **80% of lessons reaching Done status** (quiz-verified, not self-reported) before the exam date.
- **Stress reduction:** Measured via a lightweight in-app survey in a fun, low-friction quiz format — not a formal questionnaire. Students should trend toward reporting reduced anxiety and clearer sense of direction over the 6-month period.
- **Clarity of plan:** Students can open the app at any moment and immediately identify what to do next — no ambiguity about their position in the syllabus.

### Business Success

- V1 is a validation exercise: **10 students, 6 months**, covering several lessons through the full Backlog → Done lifecycle.
- Success is outcome-driven, not vanity-metric driven — no target user count, no revenue target in V1.
- If test group outcomes demonstrate that structured execution produces better results than unstructured study, proceed to V2 expansion. If findings reveal impractical assumptions, adjust before scaling.
- V1 is explicitly iterative — success criteria themselves may be refined based on real usage during the 6-month period.

### Technical Success

- App performs smoothly on a **3-year-old mid-range Android device** (target hardware baseline). Animations, transitions, and haptics must feel responsive on this device class — no jank.
- **Offline-first reliability:** Quiz completions and task status changes persist locally without any connectivity. Zero data loss from offline sessions.
- **Sync:** Offline changes sync within **5 seconds** of connectivity returning. Sync frequency is not a priority — UX performance takes precedence.
- App does not degrade in performance under extended offline use.

### Measurable Outcomes

| Metric | Target | Measurement Method |
|---|---|---|
| Weekly engagement | ≥3 sessions/week | Automatic (app usage logs) |
| Syllabus coverage | ≥80% Done (Chemistry) | App dashboard (quiz-verified) |
| Stress reduction | Positive trend over 6 months | In-app fun survey |
| Sync reliability | <5s after reconnect | Technical monitoring |
| Device performance | Smooth on 3yr-old mid-range Android | Manual QA on target device |

## User Journeys

### Journey 1: Kavya — First Week, Finding Her Footing *(Student — Success Path)*

**Persona:** Kavya, 17, Physical Science stream, Colombo. She attends tuition on Tuesday and Thursday evenings and studies on weekends. Her biggest fear is not failing — it's not knowing whether she's doing enough. She has a YouTube playlist, a stack of past paper books, and a tuition exercise book. She doesn't have a plan.

**Opening Scene:** It's Sunday evening. Kavya opens StudyBoard for the first time and sees the entire Chemistry syllabus laid out as a task board. Every topic. Every sub-lesson. All in Backlog. It's the first time she's ever seen the A/L exam as a finite, completable list.

**Rising Action:** She moves "Atomic Structure" to To-Do. Before the lesson opens, two past paper questions from that topic appear. She can't fully answer them yet — but she's curious now. She studies the lesson, reads the notes, looks at the molecular diagrams. Then she takes the quiz. 7/10. Not enough — the task re-opens. She reviews what she got wrong and retakes it. 9/10. The task slides to Done. Her phone vibrates. A small animation plays. She feels something unexpected: satisfaction. Not relief — satisfaction.

**Climax:** Four weeks in, Kavya opens the dashboard. 23% of the Chemistry syllabus is Done — quiz-verified, not self-reported. She can see her weakest topics ranked. She knows exactly what to work on this Saturday. For the first time, she doesn't feel panicked. She feels like she has a plan.

**Resolution:** By her mock exam, Kavya has 79% syllabus coverage. She walks in knowing which topics she's mastered and which ones are shaky — not guessing. She studied like she managed a project, and it shows in her result.

**Capabilities this journey requires:**
- Full syllabus visible as task board on first open (no progressive unlock)
- Curiosity-first flow: past paper questions surface before lesson content
- Quiz gate with pass threshold; fail = task re-opens, lesson stays accessible
- Real-time dashboard: coverage %, weakest topics ranked, per-topic accuracy
- Haptic + visual reward on task completion
- Offline lesson and quiz access

---

### Journey 2: Ashan — The Student Who Almost Gave Up *(Student — Edge Case: Struggle & Recovery)*

**Persona:** Ashan, 18, Biological Science stream, Kandy. Patchy mobile data — reliable only at home. Strong starter, loses momentum when things get hard. Downloaded StudyBoard in week one of the test group.

**Opening Scene:** Three weeks in, Ashan has failed the "Organic Chemistry: Hydrocarbons" quiz three times. Each time, the task re-opens. He's starting to feel the same frustration he feels with every study tool — designed for students who already understand, not for ones who are struggling. He almost closes the app for good.

**Rising Action:** But the task doesn't disappear. It sits at the top of his In Progress column every time he opens the app — not as a punishment, just as a fact: *not done yet*. His dashboard shows Hydrocarbons accuracy at 41%, clearly visible against topics he's completed. The contrast stings, but it's honest. He goes back to the lesson. Studies more carefully. Checks his tuition notes. Fourth attempt — he passes.

**Climax:** Passing that quiz on the fourth try feels different from any study win Ashan has had before. The system checked. It's real. The task moves to Done. The haptic hits. He screenshots the dashboard and sends it to a friend.

**Resolution:** Ashan's mental model shifts. Quiz failures stop feeling like failures — they become signals. "This topic needs more work." The re-open mechanic becomes motivating. He finishes the 6 months at 71% coverage — below the 80% target, but with genuine comprehension of every lesson he completed. More importantly: he stayed in the app.

**Capabilities this journey requires:**
- Failed quiz: task re-opens with clear, neutral framing — "not done yet," no punishment UI
- Retry flow: student can re-attempt quiz immediately or return later; lesson remains accessible
- Per-topic accuracy visible on dashboard so weak areas are surfaced, not hidden
- Offline lesson + quiz access essential for low-connectivity areas
- Streak mechanic must reset gracefully — failing a quiz must not break an engagement streak
- Board visual "still open" cue passively motivates return without push notifications

---

### Journey Requirements Summary

| Capability | Revealed By |
|---|---|
| Full syllabus task board visible on first open | Journey 1 |
| Curiosity-first flow (past papers before lesson) | Journey 1 |
| Quiz gate: pass to close, fail to re-open | Both |
| Lesson remains accessible after quiz failure | Journey 2 |
| Neutral, non-punishing failure UI | Journey 2 |
| Real-time dashboard: coverage %, accuracy, weakest topics | Both |
| Haptic + visual reward on task completion | Journey 1 |
| Offline lesson and quiz access | Both |
| Streak resets gracefully on quiz failure | Journey 2 |
| Per-topic accuracy surfaced clearly | Journey 2 |

## Domain-Specific Requirements

### Student Data & Privacy

**Data collected per student:** email, full name, district, school, progress metrics (task status, quiz results, accuracy per topic), engagement logs (session frequency, timestamps).

**Account lifecycle:**
- **Deactivation:** Student-initiated; account disabled, all data retained in full.
- **Deletion:** Student-initiated; student-facing profile and progress data removed from active records. Historical logs are retained (anonymised or flagged as deleted-user) for product analytics and validation purposes. System must not expose deleted-user data in any student-facing view.

**Data handling:** All data stored in Supabase (Postgres). No third-party analytics or advertising integrations in V1. Sri Lanka PDPA (2022) applies — student data is personal data and must be handled with appropriate access controls.

### Content & Assessment

- Content accuracy (lesson notes, quiz questions, past paper question mapping) is validated via a separate external process — not a V1 product requirement.
- Quiz question count per lesson is manually determined by content creators based on lesson complexity. The system enforces no minimum or maximum question count.
- Pass/fail threshold is configurable per subject at the system level; Chemistry V1 threshold is set separately from the quiz question count.
- System is responsible for enforcing the gate and re-opening logic — content calibration is a content concern, not a system concern.

### Account Registration

- Self-registration flow: email, password, name, district (dropdown), school (text or dropdown).
- No parental consent required — students are 16+ and register independently.
- No age verification gate required in V1.

### Accessibility

- Not a V1 requirement. Deferred to post-MVP.

### Risk Notes

- **Retained logs post-deletion:** Deletion must be implemented as a soft delete with anonymisation — not a hard wipe. Requirement: no deleted-user data surfaced in any student-facing screen or export.
- **District/school data sensitivity:** This data is low-sensitivity but is personal data under PDPA. Access must be restricted to system admin only (no student can view another student's profile data in V1).

## Innovation & Novel Patterns

### Detected Innovation Areas

StudyBoard introduces four novel patterns to the A/L exam preparation space, applied simultaneously for the first time in this market:

**1. Agile Execution Framework Applied to Exam Preparation**
The A/L syllabus is treated as a project backlog. Students function as both product owner and developer — defining what to work on, moving tasks through Backlog → To-Do → In Progress → Done, and maintaining a bird's-eye view of their total remaining work. No A/L preparation tool in Sri Lanka (or the broader high-stakes exam prep space, to the best of available knowledge) has applied this mental model as the core product architecture.

**2. Enforced Definition of Done**
"Completion" in every existing study tool is self-reported. StudyBoard borrows the software engineering concept of Definition of Done — a lesson is only complete when the student passes its quiz. Fail = task re-opens. This creates a fundamentally different trust relationship: every metric on the dashboard is verifiable, not claimed. This single mechanism transforms progress tracking from a vanity layer into a reliable signal.

**3. Curiosity-First Pedagogy as Default UX Flow**
Before a student studies a lesson, they encounter past paper questions from that topic. This is grounded in established learning science and psychological research: curiosity is a prerequisite for deep absorption. Knowledge that answers a question the mind has already formed is retained more deeply than knowledge delivered without context. This principle has been articulated by psychiatric and learning professionals — StudyBoard operationalises it as a default, non-optional product flow, not an optional mode.

**4. Dopamine-Driven UX as Retention Architecture**
Haptic feedback, visual completion rewards, streak mechanics, and intentional animation are not a gamification layer bolted onto a content platform — they are the primary engagement mechanism. The UX is designed to make studying feel rewarding in itself, replacing stress-driven compliance with intrinsic motivation.

### New Product Category

These four patterns combine to define a new product category: **Study OS** — a study operating system. The distinction from existing products is categorical, not incremental. Existing A/L tools are content repositories (video platforms, paper archives, note-sharing apps). StudyBoard is an execution layer. It assumes content access is solved and focuses entirely on helping students convert that content into verified, measurable progress.

### Market Context & Competitive Landscape

No documented competitor in the Sri Lankan A/L preparation market has been identified that applies any of these four patterns, let alone all four simultaneously. The competitive field operates on the content-as-product model. StudyBoard's bet is that this model is the wrong abstraction — and that the market has not yet been shown an alternative.

### Validation Approach

The V1 test group of 10 Chemistry students over 6 months is the primary validation instrument. Specific innovation hypotheses being tested:
- Does the Agile board model reduce anxiety and increase clarity? (Measured via in-app fun survey)
- Does the enforced DoD produce genuine comprehension gains? (Measured via mock exam performance)
- Does the curiosity-first flow improve retention? (Indirectly measured via quiz accuracy on first attempt vs. retakes)
- Does the dopamine-driven UX sustain engagement? (Measured via session frequency over 6 months)

### Risk Mitigation

| Innovation Risk | Mitigation |
|---|---|
| Quiz gate too hard → students stuck, disengage | Quiz calibration via separate content process; retry available immediately; lesson stays accessible |
| Curiosity-first flow feels forced or confusing | Flow is non-skippable but brief; past paper exposure is framed as a warm-up, not a test |
| Dopamine mechanics feel cheap on low-end devices | Performance is a first-class constraint; animations tuned for 3yr-old mid-range Android |
| "Study OS" framing doesn't resonate with 16-19yr olds | Category name is internal framing for V1; student-facing language to be refined based on test group feedback |

## Mobile App Specific Requirements

### Platform Requirements

- **Framework:** Flutter (Dart) — cross-platform; Android-first in V1
- **Minimum Android API level:** 30 (Android 11)
- **iOS:** Architecturally supported by Flutter but not a V1 distribution target
- **Distribution (V1):** Signed APK sideloaded directly to test group devices. No Play Store listing required.
- **Distribution (post-MVP):** Play Store submission planned; store compliance requirements deferred to that milestone.

### Device Permissions

| Permission | Purpose | Grant Type |
|---|---|---|
| INTERNET | Supabase sync when online | Auto-granted |
| ACCESS_NETWORK_STATE | Detect online/offline state for sync trigger | Auto-granted |
| VIBRATE | Haptic feedback on task completion and rewards | Auto-granted |
| POST_NOTIFICATIONS | Push notification delivery (Android 13+ only) | Runtime request |

- Camera: not required in V1
- External storage: not required (all app data uses internal scoped storage)
- Android 11 and 12 devices do not require runtime notification permission; Android 13+ requires explicit `POST_NOTIFICATIONS` runtime request at onboarding

### Offline Mode

- **Architecture:** Offline-first — all lesson content, quiz questions, past paper questions, and task state stored locally on device at first sync.
- **Behaviour without connectivity:** Full app functionality available (study lessons, take quizzes, update task status). No degraded mode.
- **Sync trigger:** On connectivity restore, offline changes (task status updates, quiz completions, engagement logs) sync to Supabase within 5 seconds.
- **Conflict resolution:** Last-write-wins for V1 (single-device-per-student assumed; no multi-device sync required).
- **Content updates:** New or updated syllabus content syncs on next app open when online. No forced update interrupts offline session.

### Push Notification Strategy

> **Scope note:** Push notifications are included in V1 (moved from post-MVP based on engagement target of ≥3 sessions/week).

- **V1 trigger:** Student has not opened the app for 3 or more consecutive days.
- **Message tone:** Encouraging, not guilt-inducing — consistent with the calm control UX philosophy.
- **Delivery:** Firebase Cloud Messaging (FCM) via Supabase integration or direct FCM setup.
- **Permission handling:** Request `POST_NOTIFICATIONS` permission at onboarding on Android 13+ devices; graceful degradation if denied (app functions fully without it).
- **Notification types in V1:** Engagement nudge only. No quiz reminders, streak alerts, or content update notifications in V1.

### Implementation Considerations

- **Rich media rendering:** Chemical formulas and molecular diagrams are image-based in V1. LaTeX rendering is not required — content team produces images directly. Images must render clearly at standard Android screen densities.
- **Animation performance:** All transitions, completion animations, and haptic sequences must perform smoothly on a 3-year-old mid-range Android device (API 30, ~2–3GB RAM, mid-tier GPU). Performance is a first-class requirement, not an afterthought.
- **APK signing:** V1 APK must be properly signed for sideloading. Students may need to enable "Install from unknown sources" — onboarding instructions must cover this.
- **App size:** Minimize initial APK size. Lesson content (text, images) is fetched from Supabase and cached locally, not bundled in APK.

## Project Scoping & Phased Development

### MVP Strategy & Philosophy

**MVP Approach:** Experience MVP — validate the core study OS experience with a small, controlled test group before any scaling decision. The 10-student cohort is not a soft launch; it is a structured experiment with defined hypotheses.

**MVP Philosophy:** Every feature in V1 must be load-bearing for validation. If removing a feature would not affect the ability to test the core hypotheses (board clarity, DoD trust, curiosity-first absorption, dopamine retention), it is not MVP.

**Resource:** Solo developer (Lahiru). All V1 build, testing, and APK distribution by a single engineer.

**Target delivery:** Sideloaded APK in students' hands within 2 weeks.

### MVP Feature Set (Phase 1)

**Core User Journeys Supported:**
- Student success path (Kavya): full board → curiosity flow → study → quiz gate → done → dashboard
- Student recovery path (Ashan): quiz failure → re-open → retry → genuine completion

**Must-Have Capabilities:**

| Capability | Rationale |
|---|---|
| Chemistry syllabus as Agile task board | Core product; without this nothing else functions |
| Backlog → To-Do → In Progress → Done workflow | The execution system; central to the value proposition |
| Curiosity-first flow (past paper questions before lesson) | Tests the pedagogy hypothesis |
| Quiz gate: pass to close, fail to re-open | The DoD trust mechanism; makes all metrics honest |
| Progress dashboard (coverage %, accuracy, weakest topics) | Validates the "bird's-eye view" anxiety reduction claim |
| Configurable coverage threshold (Chemistry = 80%) | Required for success measurement |
| Rich media support (image-based formulas and diagrams) | Chemistry content is unreadable without it |
| Haptic feedback + visual rewards + streak mechanics | Tests the dopamine retention hypothesis |
| Offline-first architecture (full functionality without connectivity) | Non-negotiable for test group students in low-connectivity areas |
| Sync within 5 seconds of reconnect | Ensures no data loss for offline sessions |
| Student auth: email/password + Google Sign-In (OAuth) | Required for validation data collection; Google Sign-In reduces friction |
| Push notification: engagement nudge after 3 days inactive | Supports ≥3 sessions/week engagement target |
| In-app fun survey (stress/satisfaction) | Primary measurement instrument for anxiety reduction |
| Account deactivation + soft delete with log retention | Data and privacy requirement (PDPA) |

### Post-MVP Features (Phase 2 — Growth)

Triggered when V1 validation confirms the model works:

- Additional A/L subjects (Physics, Biology, Economics)
- Play Store listing and standard distribution
- Shareable progress cards (WhatsApp/Facebook)
- Parent-facing progress visibility
- Push notification expansion (streak alerts, content reminders)
- Multi-device sync support

### Expansion Features (Phase 3 — Vision)

- O/L subjects and professional certification exams
- Tuition instructor cohort management dashboard
- Daily standup coaching product (human-assisted premium tier)
- In-app content marketplace
- AI-powered study recommendations
- Geographic expansion beyond Sri Lanka

### Risk Mitigation Strategy

**Technical Risks**

| Risk | Likelihood | Mitigation |
|---|---|---|
| Offline sync data loss or conflict corruption | Medium | Last-write-wins strategy; local state is source of truth until successful sync; extensive offline testing before APK delivery |
| Animation jank on low-end Android devices | Medium | Performance profiling on target device class during build; animations must be tested on API 30 hardware before distribution |
| Rich media images slow to load or render incorrectly | Low-Medium | Images cached locally at first sync; no lazy loading of lesson content mid-session |

**Market Risks**

| Risk | Likelihood | Mitigation |
|---|---|---|
| Test group engagement falls below 3 sessions/week | Medium | Investigate root cause before any product change — distinguish UX friction, content gaps, or external factors (exam schedule, personal circumstances). Do not adjust product based on <3 weeks of data. |
| Students find curiosity-first flow confusing or annoying | Low-Medium | Monitor in-app survey responses and quiz first-attempt accuracy; qualitative check-in with test group at week 4 |
| Quiz gate perceived as punishing rather than motivating | Low | Framing is "not done yet" not "failed"; monitor drop-off rates per topic |

**Resource Risks**

| Risk | Likelihood | Mitigation |
|---|---|---|
| 2-week APK delivery window too tight for full feature set | High | If timeline pressure hits, cut in this sequence: (1) in-app survey, (2) push notifications, (3) streak mechanics. Core non-negotiables: task board, quiz gate, curiosity flow, dashboard, offline mode. |
| Solo developer bottleneck post-launch | Medium | V1 scope is intentionally minimal; no new features enter build until validation data is collected |

## Functional Requirements

### User Account Management

- **FR1:** A student can register an account using email and password, or via Google Sign-In (OAuth)
- **FR2:** A student can log in using email and password, or via their linked Google account
- **FR3:** A student can link a Google account to their StudyBoard account for authentication
- **FR4:** A student can update their profile information (name, district, school)
- **FR5:** A student can deactivate their account, disabling access while retaining all data intact
- **FR6:** A student can request account deletion, removing their profile and progress from all student-facing views while anonymised historical logs are retained

### Syllabus & Task Board

- **FR7:** A student can view the complete A/L Chemistry syllabus in a Backlog view — all tasks listed and available to be pulled into the active board (Jira backlog model)
- **FR8:** A student can view their active tasks as a visual Kanban board with To-Do, In Progress, and Done columns, with lesson tasks displayed as movable cards (Jira sprint board model)
- **FR9:** A student can pull a task from the Backlog into the To-Do column on their active Kanban board
- **FR10:** A student can move a task card from To-Do to In Progress on the Kanban board
- **FR11:** A student can view tasks filtered by content track (Theory, Past Papers, Future Papers) across both Backlog and Kanban board views
- **FR12:** A student's board includes a Future Papers content track; architecturally present and visible in V1 but may contain no tasks
- **FR13:** A student can see the status of every lesson and sub-lesson at any time across both Backlog and Kanban board views
- **FR14:** The system prevents a student from moving a task to Done without passing its associated quiz

### Content & Learning Flow

- **FR15:** A student is shown past paper questions from a lesson's topic before lesson content is displayed (curiosity-first flow — non-skippable)
- **FR16:** A student can access lesson content (notes, diagrams, rich media) for any lesson on their board
- **FR17:** A student can view rich media content including chemical formulas, molecular diagrams, and images within lessons and quiz questions
- **FR18:** A student can access lesson content and past paper questions without an internet connection
- **FR19:** A student's local content library updates automatically when new or updated syllabus content is available and connectivity is active

### Assessment & Progress Verification

- **FR20:** A student can take a quiz for any lesson they are currently studying
- **FR21:** The system evaluates a student's quiz attempt and determines pass or fail based on the subject's configured threshold
- **FR22:** When a student fails a quiz, the lesson task re-opens to In Progress — framed neutrally as "not done yet"
- **FR23:** When a student passes a quiz, the lesson task is marked Done and closed
- **FR24:** A student can re-attempt a quiz immediately after failing, or return to it at any later time
- **FR25:** A student can access lesson content after a quiz failure to review before retrying
- **FR26:** The system records each quiz attempt's score and pass/fail outcome

### Progress Dashboard & Analytics

- **FR27:** A student can view their overall syllabus coverage percentage (quiz-verified Done lessons vs. total lessons)
- **FR28:** A student can view their past paper completion percentage per topic
- **FR29:** A student can view their accuracy rate per topic across all quiz attempts
- **FR30:** A student can view a ranked list of their weakest topics, sorted by accuracy ascending
- **FR31:** The system displays a student's progress relative to the subject's configured completion threshold (Chemistry = 80%)
- **FR32:** A student can view their current engagement streak (consecutive days of app activity)

### Engagement & Motivation

- **FR33:** The system delivers haptic feedback when a student completes a task
- **FR34:** The system displays a visual reward animation when a student completes a task
- **FR35:** The system maintains and displays a streak counter tracking consecutive days of app use
- **FR36:** The system resets a student's streak counter when a day is missed, without penalty or punishing UI
- **FR37:** A student can respond to a periodic in-app satisfaction and stress survey presented in a lightweight, fun quiz format
- **FR38:** The system records in-app survey responses for validation and product analysis

### Offline & Sync

- **FR39:** A student can access all lesson content, quiz questions, and their task board without an internet connection
- **FR40:** A student can complete quizzes and update task status without an internet connection, with all changes persisted locally
- **FR41:** The system automatically syncs locally-stored changes to the server within 5 seconds of connectivity returning
- **FR42:** The system detects network state changes and triggers sync without requiring user action
- **FR43:** The system does not interrupt or degrade an active session when connectivity state changes

### Notifications

- **FR44:** The system sends an engagement nudge notification to a student who has not opened the app for 3 or more consecutive days
- **FR45:** A student can grant or deny notification permission during onboarding on devices that require it
- **FR46:** The app provides full functionality to a student who has denied notification permission

## Non-Functional Requirements

### Performance

All performance targets apply to the baseline device: 3-year-old mid-range Android (API 30, ~2–3GB RAM).

| Requirement | Target |
|---|---|
| Cold start to fully interactive board | ≤ 3 seconds |
| Task card interaction response (tap, move) | ≤ 200ms |
| Quiz answer submission and result display | ≤ 1 second |
| Dashboard metrics render (all data) | ≤ 2 seconds |
| Lesson content render from local cache (offline) | ≤ 2 seconds |
| Animation frame rate (transitions, rewards, haptics) | 60fps sustained |
| Offline changes sync after connectivity returns | ≤ 5 seconds |

Animations, haptic sequences, and card transitions must perform at these targets without degradation during extended offline use or after prolonged sessions.

### Security

- All data in transit encrypted via HTTPS/TLS — enforced at the Supabase layer; no plain HTTP calls permitted
- All data at rest encrypted in Supabase (Postgres encryption at rest)
- Student progress data is accessible only to the owning student account — enforced via Supabase Row-Level Security (RLS) policies
- Google Sign-In implemented via standard OAuth 2.0 — no Google credentials stored by the app; only OAuth tokens handled
- Soft-deleted accounts: all PII (name, email, district, school) anonymised in retained logs immediately upon deletion request — no PII in historical records
- No student can access another student's profile, progress, or quiz data at any point

### Reliability

- **Zero data loss guarantee:** All quiz completions and task status changes must be persisted to local storage before any sync is attempted — local state is always the source of truth
- **Crash resilience:** Locally-persisted offline data must survive app crash, force-close, or device restart
- **Idempotent sync:** Retrying a failed sync operation must not create duplicate records or corrupt existing state
- **Graceful sync failure:** If a sync attempt fails (e.g., server unavailable), queued offline changes must be retained locally and retried — no silent data loss
- **No session interruption:** A sync event must not interrupt or visually disrupt an in-progress study session or quiz attempt

### Integration

- **Google Sign-In:** Implemented via Google Sign-In for Android SDK, compliant with OAuth 2.0 standards; token refresh handled transparently without requiring re-login
- **Supabase:** All API calls authenticated with Supabase JWT tokens; RLS policies enforced server-side on all data access
- **Firebase Cloud Messaging (FCM):** Push notifications delivered via FCM; app handles FCM token registration and refresh gracefully; if FCM is unreachable, the app continues to function normally without notification delivery
