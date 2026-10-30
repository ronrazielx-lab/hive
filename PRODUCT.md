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
| היום (Today) | Greeting, progress ring, both honey balances + the couple jar, everything due today from ניל and בית grouped by morning / evening / whenever. Quick-add box for a one-off task for today. |
| ניל (Neil) | Checklists by sub-category (תיק לגן, בוקר, ערב ואמבטיה, בריאות, add your own). Today's items are checkable; items for other days sit in a folded row. |
| בית (Home) | Home tasks: due today (checkable), the other recurring ones and projects, and an "on hold" shelf for things that aren't now (hang the shelf, sort the storage). One tap moves a task back to active. |
| סופר (Super) | Shared grocery list. Quick-add, suggestion chips, check items in the store, clear cart. |
| שלי (Mine) | Private tasks that live only on this phone and are never written to the shared database, so the other partner cannot see them. Due-today ones also appear in היום under "🔒 רק שלי". Completing one earns personal honey only, not jar honey. |
| פרסים (Rewards) | Each partner's personal honey balance, the couple jar, reward lists (personal and couple) with prices and a redeem button, recent redemptions, 7-day streak, settings. |

## Task model

- title, area (ניל / בית / רק שלי), Neil sub-category, status (active / hold)
- time of day (morning / evening / any)
- owner: צ'ילד, נטן דה נטן, or "whoever gets to it first"
- repeat: `days [0..6]` · `every N days from date` · `once on date` (one-offs carry over until done)
- points: 1 / 2 / 3 / 5 honey

## Points and rewards

Every completed task gives its honey to the person who did it **and** to the shared jar. Personal rewards (massage, a dedicated song, a love letter, sleeping in, breakfast in bed, a free evening) are bought from one's own balance; the other partner delivers. Couple rewards (popcorn date on the couch, phone-free movie night, dinner out, morning coffee walk, board-game night) are bought from the jar. Rewards are editable; prices are in honey.

## What the demo does today

Installable PWA in `app/` (index.html, manifest, service worker, icons). Works offline once installed. Both phones attach automatically to one Firebase Realtime Database "house" (no pairing; each phone only asks once who is using it; offline outbox). Hosted on GitHub Pages via the workflow in `.github/workflows/`. Setup steps are in README.md.

Local preview: `python -m http.server 8765 --directory app` then open http://localhost:8765. Icons regenerate with `app/make-icons.ps1`.

## Roadmap

1. ~~**Real sync.**~~ Done: Firebase Realtime Database, one house per couple, invite link + code pairing, outbox for offline writes. Needs the Firebase project created once (README).
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
