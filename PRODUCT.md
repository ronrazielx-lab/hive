# הכוורת (The Hive) — shared home tasks for two

A playful, Hebrew, phone-first app that turns the recurring chores of a household with a small kid into something two partners actually enjoy opening.

## The problem it solves

Home tasks are mostly *recurring* and *invisible*. The mental load of remembering them ("did anyone put the water bottle in Neil's bag?") is heavier than the tasks themselves, and it tends to sit with one person. The app makes the list visible, shared, and a little bit fun, so neither partner has to be the reminder.

## Core concept

- **The day is the unit.** The home screen is "today": only what is due today, grouped by morning / evening / whenever. Nothing else competes for attention.
- **Repeat rules do the remembering.** Every task carries a schedule (daily, kindergarten days Sun–Thu, specific weekdays, every N days, one-off). The app generates today's list; nobody re-enters "check diapers" every morning.
- **Team, not scoreboard.** Every completed task drops honey into one shared weekly jar. When it fills, the couple earns a reward they chose themselves. Two people, one jar. Per-person points are shown, but the win condition is shared.
- **Small delights on every tap.** Satisfying check animation, a soft sound, a haptic buzz, confetti when the day is fully done. These are what make someone *want* to open the app.

## Screens

| Tab | Purpose |
|---|---|
| היום (Today) | Greeting, progress ring, honey jar, today's tasks by time of day. Tap the circle to complete. |
| כל המשימות (All tasks) | Every recurring task grouped by category (גן, בית, custom). Tap to edit schedule, owner, points. Add categories. |
| קניות (Shopping) | Shared grocery list. Quick-add, suggestion chips, check items in the store, clear cart. |
| אנחנו (Us) | Both partners' weekly honey, the shared jar and reward, 7-day streak strip, settings. |

## Task model

- title, category, time of day (morning / evening / any)
- owner: partner A, partner B, or "whoever gets to it first"
- repeat: `days [0..6]` · `every N days from date` · `once on date` (one-offs carry over until done)
- points: 1 / 2 / 3 honey drops (light / medium / heavy)

## What the demo does today

Installable PWA in `app/` (index.html, manifest, service worker, icons). Works offline once installed. Data is saved in the browser on the device it runs on (each phone has its own copy), so the two lists are not yet synced. Needs HTTPS hosting (GitHub Pages) to install on phones.

Local preview: `python -m http.server 8765 --directory app` then open http://localhost:8765. Icons regenerate with `app/make-icons.ps1`.

## Roadmap

1. **Real sync (the next step that matters).** A small backend (Supabase or Firebase) so both phones share one list live. This is what turns the demo into the product.
2. **Push notifications.** Morning digest ("3 kindergarten things before you leave"), evening nudge, "your partner just finished X". Requires a PWA with a service worker and the backend from step 1.
3. ~~Install as an app.~~ Done: PWA manifest, service worker, bee icon.
4. **Rotation.** Tasks marked "whoever" can auto-alternate between partners each occurrence.
5. **Kid mode.** A big-button view Neil can use in a year or two: pick up toys, brush teeth, earn a sticker.
6. **Weekly recap.** Sunday-morning card: honey earned, streak, funniest task of the week.
7. **Voice / quick capture.** "Add wipes to shopping" from a phone widget or a shared WhatsApp bot.

## Open questions for the two of you

- Name and mascot: keep the bee/hive metaphor, or something else?
- Does a weekly reward feel motivating or gimmicky? Try it for two weeks and decide.
- Which of you tends to carry the mental load? Give that person the "whoever" tasks to *un*-assign, not to assign.
