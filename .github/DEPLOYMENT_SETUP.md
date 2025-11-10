# Quick Deployment Setup Guide

## 🚀 Get Your Game Online in 5 Minutes!

### Option 1: GitHub Pages (Easiest - No Keys Needed!)

1. **Enable GitHub Pages**:
   ```bash
   # After pushing to main, go to:
   # https://github.com/YOUR-USERNAME/mini-card-rpg/settings/pages
   #
   # Set:
   # - Source: Deploy from branch
   # - Branch: gh-pages
   # - Folder: / (root)
   #
   # Click Save
   ```

2. **Push to main branch**:
   ```bash
   git checkout main
   git merge claude/card-dungeon-game-setup-011CUyMbbNAxDECqccd1GzVc
   git push origin main
   ```

3. **Wait 2-5 minutes** and visit:
   ```
   https://YOUR-USERNAME.github.io/mini-card-rpg
   ```

**That's it!** Your game is now live on GitHub Pages! 🎉

---

### Option 2: itch.io (Best for Game Distribution)

1. **Create itch.io game**:
   - Go to https://itch.io/dashboard
   - Click "Create new project"
   - Title: "Mini Card Dungeon"
   - Project URL: Choose your slug (e.g., "mini-card-dungeon")
   - Kind: HTML
   - Save as Draft

2. **Get API Key**:
   - Visit https://itch.io/user/settings/api-keys
   - Click "Generate new API key"
   - Copy the key immediately (shown only once!)

3. **Add GitHub Secrets**:
   - Go to: `https://github.com/YOUR-USERNAME/mini-card-rpg/settings/secrets/actions`
   - Add three secrets:
     - `BUTLER_API_KEY`: Your API key from step 2
     - `ITCH_USER`: Your itch.io username
     - `ITCH_GAME`: Your game slug from step 1

4. **Enable in workflow**:
   ```bash
   # Uncomment the export-itch job in .github/workflows/deploy.yml
   # Lines 58-80 (remove the # at start of each line)
   ```

5. **Push to main**:
   ```bash
   git add .github/workflows/deploy.yml
   git commit -m "feat: enable itch.io deployment"
   git push origin main
   ```

6. **Check your itch.io dashboard** - game will be uploaded!

---

### Option 3: Cloudflare Pages (Custom Domain)

1. **Get Cloudflare API Token**:
   - Log into Cloudflare
   - My Profile → API Tokens
   - Create Token → "Edit Cloudflare Workers"
   - Copy token

2. **Get Account ID**:
   - Cloudflare Dashboard
   - Select your domain
   - Account ID is in the right sidebar

3. **Add GitHub Secrets**:
   - Go to: `https://github.com/YOUR-USERNAME/mini-card-rpg/settings/secrets/actions`
   - Add two secrets:
     - `CLOUDFLARE_API_TOKEN`: Token from step 1
     - `CLOUDFLARE_ACCOUNT_ID`: ID from step 2

4. **Enable workflow**:
   ```bash
   # Rename the example file
   mv .github/workflows/cloudflare-pages.yml.example .github/workflows/cloudflare-pages.yml

   # Edit PROJECT_NAME in the file to match your desired project name
   ```

5. **Push to main**:
   ```bash
   git add .github/workflows/cloudflare-pages.yml
   git commit -m "feat: enable Cloudflare Pages deployment"
   git push origin main
   ```

6. **Set up custom domain** (optional):
   - Cloudflare Pages dashboard
   - Select your project
   - Custom domains → Add domain

---

## 🎯 Recommended Setup

**For Development:**
- ✅ Use **GitHub Pages** - free, automatic, perfect for testing

**For Release:**
- ✅ Add **itch.io** - best for players to find and play your game

**For Custom Domain:**
- ✅ Add **Cloudflare Pages** - if you want `game.yourdomain.com`

---

## Quick Command Reference

### Check if workflow is working:
```bash
# View in browser:
https://github.com/YOUR-USERNAME/mini-card-rpg/actions

# Or with gh CLI:
gh workflow list
gh run list --workflow=deploy.yml
```

### Manually trigger deployment:
```bash
gh workflow run deploy.yml
```

### View deployed sites:
```bash
# GitHub Pages
https://YOUR-USERNAME.github.io/mini-card-rpg

# itch.io
https://YOUR-USERNAME.itch.io/YOUR-GAME-SLUG

# Cloudflare
https://mini-card-dungeon.pages.dev  # Or custom domain
```

---

## Troubleshooting

### "gh-pages branch not found"
- Wait for first workflow to complete
- Check Actions tab for errors
- Branch will be created automatically on first deploy

### "403 Forbidden on GitHub Pages"
- Ensure Pages is enabled in Settings
- Check that gh-pages branch is selected
- Wait a few minutes for DNS propagation

### "Butler authentication failed"
- Double-check BUTLER_API_KEY in secrets
- Regenerate API key on itch.io if needed
- Ensure no extra spaces when pasting

### "Cloudflare project not found"
- Project is created automatically on first deploy
- Check CLOUDFLARE_ACCOUNT_ID is correct
- Verify API token has correct permissions

---

## What Gets Deployed?

Every push to `main` branch will:

1. ✅ Build Godot project for HTML5
2. ✅ Export to `build/web/` directory
3. ✅ Deploy to GitHub Pages (always)
4. ✅ Deploy to itch.io (if enabled)
5. ✅ Deploy to Cloudflare (if enabled)

Pushes to `claude/*` branches will:
- ✅ Build the game
- ✅ Store artifact (downloadable from Actions)
- ❌ NOT deploy anywhere (safe for testing)

---

## Next Steps After Setup

1. **Test the deployment** - make a small change and push
2. **Add a build badge** to README (optional)
3. **Configure itch.io embed settings** for best experience
4. **Share your game link!** 🎮

---

Need help? Check the full **DEPLOYMENT.md** for detailed documentation!
