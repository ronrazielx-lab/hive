# הכוורת — Manager

- `app/` — the installable PWA. Deployed as-is to GitHub Pages by `.github/workflows/pages.yml` on every push to `main`.
- `PRODUCT.md` — product concept, screens, roadmap.
- `.claude/launch.json` — local preview server config.

Run locally:

    python -m http.server 8765 --directory app

## Sync between the two phones (Firebase Realtime Database)

The app syncs through one Firebase "house" per couple. Without a Firebase config it runs in local-only mode
(each phone keeps its own copy). One-time setup, about five minutes:

1. Go to https://console.firebase.google.com → **Add project** → name it `hive` (Google Analytics can be off).
2. In the project: **Build → Realtime Database → Create database**. Pick a region (Belgium `europe-west1` is closest), start in **locked mode**.
3. Open the **Rules** tab and replace the rules with:

       {
         "rules": {
           "houses": {
             "$code": { ".read": true, ".write": true }
           }
         }
       }

   Anyone who knows a house code can read and write that house; codes are 8 random characters and the list of houses is not readable.
4. **Project settings (gear) → Your apps → Add app → Web (`</>`)**. Register it (no hosting needed) and copy the `firebaseConfig` object.
5. Paste `apiKey`, `authDomain`, `databaseURL`, `projectId`, `appId` into the `FIREBASE` constant at the top of the script in `app/index.html`, commit, push. GitHub Pages redeploys in about a minute.

Pairing the phones, inside the app (tab **אנחנו → סנכרון בין הטלפונים**):

- Phone 1: **יצירת כוורת משותפת**. The phone's current tasks and shopping list become the shared copy.
- Phone 1: **שליחת הזמנה** sends a link + the house code over WhatsApp or similar.
- Phone 2: open the link (Android: joins straight away), or install the app first and type the code in the same card (iPhone: the home-screen app has its own storage, so type the code there).

How sync behaves: every change is a small targeted write, queued in an outbox on the device so nothing is lost if the app is closed while offline. `me` (which partner uses this phone) and the sound toggle stay per-device.

## Installing on phones

- **Android (Chrome):** open the site, accept the "install" banner, or menu → *Add to Home screen*.
- **iPhone (Safari):** open the site, Share → *Add to Home Screen*.
