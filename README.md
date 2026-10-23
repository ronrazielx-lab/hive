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

Anyone who knows a house code can read and write that house; codes are 8 random characters and the list of houses is not readable.
Console: https://console.firebase.google.com/project/hive-40adf/database (sign in with the personal account).

Pairing the phones, inside the app (tab **אנחנו → סנכרון בין הטלפונים**):

- Phone 1: **יצירת כוורת משותפת**. The phone's current tasks and shopping list become the shared copy.
- Phone 1: **שליחת הזמנה** sends a link + the house code over WhatsApp or similar.
- Phone 2: open the link (Android: joins straight away), or install the app first and type the code in the same card (iPhone: the home-screen app has its own storage, so type the code there).

How sync behaves: every change is a small targeted write, queued in an outbox on the device so nothing is lost if the app is closed while offline. `me` (which partner uses this phone) and the sound toggle stay per-device.

## Deploying

After committing on `main`, publish the app folder to the `gh-pages` branch:

    git push origin main
    git push origin "$(git subtree split --prefix app main):gh-pages" --force

GitHub Pages serves it at https://ronrazielx-lab.github.io/hive/ within a minute or two.

## Installing on phones

- **Android (Chrome):** open the site, accept the "install" banner, or menu → *Add to Home screen*.
- **iPhone (Safari):** open the site, Share → *Add to Home Screen*.
