# Setup (owner's one-time steps)

## GitHub Pages
1. On github.com open the repository `escape`: **Settings → Pages**.
2. Under **Build and deployment → Source** choose **GitHub Actions**.
3. Re-run the latest "CI and deploy" run (Actions tab → the run → **Re-run
   jobs**), or wait for the next push.

The game is then at https://cmzueger.github.io/escape/.

If the deploy job says the branch is not allowed: **Settings → Environments →
github-pages → Deployment branches** and allow `main`.

## Later
- A custom domain: Settings → Pages → Custom domain, and a CNAME record at
  the DNS provider pointing to `cmzueger.github.io`.
