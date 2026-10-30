# הכוורת — Manager

- `app/` — the installable PWA. Deployed to GitHub Pages from the `gh-pages` branch (the contents of `app/`).
- `PRODUCT.md` — product concept, screens, roadmap.
- `.claude/launch.json` — local preview server config.

Run locally:

    python -m http.server 8765 --directory app

## Sync between the two phones (Firebase Realtime Database)

The app syncs through one Firebase "house" per couple. Firebase project **hive-40adf** (Ron's personal Google
account, free Spark plan), Realtime Database in Belgium (europe-west1). The web config lives in the `FIREBASE`
constant at the top of the script in `app/index.html`; a Firebase web API key is not a secret, access is governed
by the database rules:

    {
      "rules": {
        "houses": {
          "$code": { ".read": true, ".write": true }
        }
      }
    }

Anyone who knows a house code can read and write that house; the list of houses is not readable.
Console: https://console.firebase.google.com/project/hive-40adf/database (sign in with the personal account).

There is no pairing step: both phones attach automatically to the one house named by the `HOUSE` constant next to
the Firebase config. The first phone to open the app seeds the house with its local copy; every later phone just
loads it. Each phone asks once "who is using this phone?" so honey is credited to the right partner (changeable
any time via the avatar toggle at the top). The house code is visible in the public source; the data is a chores
list, so that trade-off was accepted. To start over with an empty hive, change `HOUSE` and redeploy.

Private tasks (the שלי tab, or "רק שלי" in the task form) are stored only in that phone's localStorage and never sent to Firebase; only an anonymous completion record (honey, no title) is synced so the personal balance stays right across devices. Clearing the browser's site data deletes them.

How sync behaves: every change is a small targeted write, queued in an outbox on the device so nothing is lost if the app is closed while offline. `me` (which partner uses this phone) and the sound toggle stay per-device.

## Deploying

After committing on `main`, publish the app folder to the `gh-pages` branch:

    git push origin main
    git push origin "$(git subtree split --prefix app main):gh-pages" --force

GitHub Pages serves it at https://ronrazielx-lab.github.io/hive/ within a minute or two.

## Installing on phones

- **Android (Chrome):** open the site, accept the "install" banner, or menu → *Add to Home screen*.
- **iPhone (Safari):** open the site, Share → *Add to Home Screen*.
