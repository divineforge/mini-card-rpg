# CI/CD Pipeline Documentation

## Overview

This project uses GitHub Actions to automatically build and deploy the game on every push to main or claude/* branches.

## Current Setup

### Automated Workflows

#### 1. Web Build (Always Active)
- **Trigger**: Push to main or claude/* branches
- **Platform**: GitHub Actions
- **Container**: godot-ci:4.4 (pre-configured with Godot and export templates)
- **Output**: HTML5 build in `build/web/`

#### 2. GitHub Pages Deployment (Always Active)
- **Trigger**: Push to main branch only
- **URL**: Will be available at `https://<username>.github.io/mini-card-rpg`
- **Branch**: Deploys to `gh-pages` branch
- **Automatic**: No configuration needed!

#### 3. itch.io Deployment (Optional - Currently Disabled)
- **Status**: Commented out in workflow
- **Requires**: Butler API key and itch.io game slug
- **To Enable**: See instructions below

#### 4. Cloudflare Pages (Optional - Not Yet Configured)
- **Status**: Can be added if desired
- **Requires**: Cloudflare API token
- **To Enable**: See instructions below

---

## Quick Start

### Enable GitHub Pages

1. Go to your repo: `https://github.com/<username>/mini-card-rpg`
2. Click **Settings** → **Pages**
3. Under "Source", select:
   - Branch: `gh-pages`
   - Folder: `/ (root)`
4. Click **Save**
5. Wait 2-5 minutes after next push to main
6. Your game will be live at: `https://<username>.github.io/mini-card-rpg`

---

## Optional: Enable itch.io Deployment

### Step 1: Get itch.io API Key

1. Go to https://itch.io/user/settings/api-keys
2. Click "Generate new API key"
3. Copy the key (you'll only see it once!)

### Step 2: Get Your Game Info

1. Create a new game on itch.io (if you haven't):
   - Go to https://itch.io/dashboard
   - Click "Create new project"
   - Fill in basic info
   - Set to "Draft" (don't publish yet)
   - Note your game URL: `https://<username>.itch.io/<game-name>`

2. Extract your details:
   - `ITCH_USER`: Your itch.io username
   - `ITCH_GAME`: Your game slug (the `<game-name>` part of URL)

### Step 3: Add Secrets to GitHub

1. Go to your repo → **Settings** → **Secrets and variables** → **Actions**
2. Click "New repository secret"
3. Add these three secrets:

```
Name: BUTLER_API_KEY
Value: <your-itch-api-key>

Name: ITCH_USER
Value: <your-itch-username>

Name: ITCH_GAME
Value: <your-game-slug>
```

### Step 4: Uncomment the Workflow

In `.github/workflows/deploy.yml`, uncomment the `export-itch` job (lines starting with `#`).

### Step 5: Push to Main

The next push to `main` will automatically deploy to itch.io!

---

## Optional: Enable Cloudflare Pages

### Step 1: Get Cloudflare API Token

1. Log into Cloudflare dashboard
2. Go to **Profile** → **API Tokens**
3. Click "Create Token"
4. Use template: "Edit Cloudflare Workers"
5. Copy the token

### Step 2: Add Secret to GitHub

```
Name: CLOUDFLARE_API_TOKEN
Value: <your-token>

Name: CLOUDFLARE_ACCOUNT_ID
Value: <your-account-id>  # Found in Cloudflare dashboard
```

### Step 3: Add Cloudflare Job

I can add a Cloudflare Pages deployment job if you provide:
- Your Cloudflare account ID
- Your desired project name
- Custom domain (optional)

---

## Workflow Behavior

### On Push to `claude/*` branches:
- ✅ Builds web export
- ✅ Uploads artifact (available in Actions tab)
- ❌ Does NOT deploy anywhere (safe for testing)

### On Push to `main` branch:
- ✅ Builds web export
- ✅ Deploys to GitHub Pages
- ✅ Deploys to itch.io (if configured)
- ✅ Deploys to Cloudflare (if configured)

### Manual Trigger:
- Go to **Actions** tab → **Build and Deploy Game** → **Run workflow**
- Choose branch and click "Run workflow"

---

## Testing Your Build

### Before Deployment (on PR/branch):
1. Go to **Actions** tab
2. Find your workflow run
3. Download the "web" artifact
4. Unzip and open `index.html` locally

### After Deployment to GitHub Pages:
1. Visit `https://<username>.github.io/mini-card-rpg`
2. Game should load in browser
3. Test on mobile/desktop

### After Deployment to itch.io:
1. Go to your itch.io game dashboard
2. Click "View game" (even if draft)
3. Test the embedded version

---

## Troubleshooting

### Build Fails
- Check **Actions** tab for error logs
- Common issues:
  - Export preset name must match exactly: "Web"
  - project.godot must be in repo root
  - Check Godot version compatibility

### GitHub Pages 404
- Ensure GitHub Pages is enabled in repo settings
- Check that `gh-pages` branch exists
- Wait 5 minutes after first deployment

### itch.io Upload Fails
- Verify API key is correct
- Check ITCH_USER and ITCH_GAME match your game URL
- Ensure game exists on itch.io (even as draft)

### Cloudflare Fails
- Verify API token has correct permissions
- Check account ID is correct
- Ensure project name is valid

---

## Custom Domain Setup

### For GitHub Pages:
1. In repo **Settings** → **Pages**
2. Add your custom domain
3. Configure DNS:
   ```
   CNAME   www   <username>.github.io
   A       @     185.199.108.153
   A       @     185.199.109.153
   A       @     185.199.110.153
   A       @     185.199.111.153
   ```

### For itch.io:
1. itch.io Pro account required for custom domains
2. Configure in game settings

### For Cloudflare Pages:
1. Domain must be in Cloudflare
2. Automatically handled in project settings
3. Can enable preview URLs for branches

---

## Performance Optimization

The workflow is configured for optimal performance:
- ✅ Uses official Godot CI container (pre-installed templates)
- ✅ Caches artifacts between jobs
- ✅ Only deploys on main branch
- ✅ Parallel uploads to multiple platforms
- ✅ LFS support for large assets

---

## Monitoring

### Check Build Status:
- Badge in README (will add if you want)
- **Actions** tab shows all runs
- Email notifications on failure (configurable)

### Check Deployments:
- GitHub Pages: Check **Deployments** in repo
- itch.io: Check game analytics dashboard
- Cloudflare: Check Pages dashboard

---

## Next Steps

1. **Enable GitHub Pages** (follow Quick Start above)
2. **Test** by pushing to main branch
3. **Optional**: Set up itch.io if you want
4. **Optional**: Set up Cloudflare if you want custom domain

---

## Need Help?

- GitHub Actions docs: https://docs.github.com/en/actions
- Godot CI container: https://github.com/abarichello/godot-ci
- Butler (itch.io): https://itch.io/docs/butler/
- Cloudflare Pages: https://developers.cloudflare.com/pages/

---

## Cost

All options are **FREE** for this use case:
- ✅ GitHub Actions: 2000 minutes/month free (public repos get unlimited)
- ✅ GitHub Pages: Free for public repos
- ✅ itch.io: Free (forever)
- ✅ Cloudflare Pages: 500 builds/month free

You're all set! 🚀
