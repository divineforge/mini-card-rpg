# GitHub Actions Debugging Guide

## 🔍 How to Check for Errors

### Method 1: GitHub Web Interface

1. Go to your repository: `https://github.com/divineforge/mini-card-rpg`
2. Click the **Actions** tab at the top
3. You'll see a list of workflow runs
4. Click on any run to see details
5. Click on the job name (e.g., "Web Export") to see logs
6. Failed steps will have a ❌ red X
7. Click on any step to expand and see detailed logs

### Method 2: GitHub CLI (if installed)

```bash
# List recent workflow runs
gh run list

# View a specific run
gh run view <run-id>

# Watch a run in real-time
gh run watch

# View logs
gh run view <run-id> --log
```

### Method 3: Email Notifications

GitHub will email you when a workflow fails (if enabled in your settings).

---

## 🐛 Common Errors and Fixes

### Error 1: "Export preset not found: Web"

**Symptom:**
```
ERROR: Invalid export preset name: Web
```

**Cause:** Export preset name in workflow doesn't match `export_presets.cfg`

**Fix:**
```bash
# Check your export preset name
cat export_presets.cfg | grep "^name="

# Update workflow if needed (should be "Web")
# In .github/workflows/deploy.yml line 39
```

**Already Fixed!** ✅ Your export preset is correctly named "Web"

---

### Error 2: "godot: command not found"

**Symptom:**
```
/bin/bash: line 1: godot: command not found
```

**Cause:** Godot not in container PATH (rare with godot-ci image)

**Fix:** The workflow uses the official `barichello/godot-ci:4.4` container which has Godot pre-installed. If this fails, try:
```yaml
container:
  image: barichello/godot-ci:4.3  # Try different version
```

---

### Error 3: "Permission denied" when deploying to GitHub Pages

**Symptom:**
```
Error: The deploy step encountered an error: The process '/usr/bin/git' failed with exit code 128
```

**Cause:** GitHub Actions doesn't have permission to push to `gh-pages` branch

**Fix:**
1. Go to repo **Settings** → **Actions** → **General**
2. Scroll to "Workflow permissions"
3. Select **Read and write permissions**
4. Click **Save**

---

### Error 4: "Failed to export project"

**Symptom:**
```
ERROR: No export template found at the expected path
```

**Cause:** Export templates not properly set up in container

**Fix:** The Setup step should handle this. If it fails, check that the template version matches:
```yaml
env:
  GODOT_VERSION: 4.4  # Must match container version
```

---

### Error 5: "Resource not found" or "Scene not found"

**Symptom:**
```
ERROR: res://main.tscn: Resource file not found.
```

**Cause:** Missing files or incorrect paths in project.godot

**Fix:**
1. Ensure all `.tscn` files are committed to git
2. Check `project.godot` has correct `run/main_scene` path
3. Ensure files aren't in `.gitignore`

---

### Error 6: Build succeeds but GitHub Pages shows 404

**Symptom:** Build completes, but website shows "404 Not Found"

**Causes & Fixes:**

1. **GitHub Pages not enabled:**
   - Go to Settings → Pages
   - Select `gh-pages` branch
   - Wait 2-5 minutes

2. **Wrong branch selected:**
   - Must be `gh-pages`, not `main`

3. **Wrong folder:**
   - Must be `/ (root)`, not `/docs`

4. **DNS propagation:**
   - Wait up to 10 minutes after first deploy

---

### Error 7: "uses: actions/checkout@v4" fails

**Symptom:**
```
Error: Unable to resolve action
```

**Cause:** GitHub Actions version incompatibility

**Fix:** Change to older version:
```yaml
- uses: actions/checkout@v3  # Instead of v4
```

---

### Error 8: Container fails to start

**Symptom:**
```
Error: Container creation failed
```

**Cause:** Docker image not available or network issue

**Fix:** Try without container:
```yaml
jobs:
  export-web:
    runs-on: ubuntu-22.04
    # Remove container section, install Godot manually
    steps:
      - name: Install Godot
        run: |
          wget https://downloads.tuxfamily.org/godotengine/4.4/Godot_v4.4-stable_linux.x86_64.zip
          unzip Godot_v4.4-stable_linux.x86_64.zip
          chmod +x Godot_v4.4-stable_linux.x86_64
          sudo mv Godot_v4.4-stable_linux.x86_64 /usr/local/bin/godot
```

---

## 🔧 How to Share Errors with Me

If you get an error you can't solve:

1. **Copy the error logs:**
   - Click on the failed step in Actions tab
   - Copy the error message (usually the last 10-20 lines)

2. **Share with me:**
   ```
   Hey, my GitHub Action failed with this error:

   [paste error here]
   ```

3. **I'll help you fix it!** I can:
   - Identify the issue
   - Update the workflow
   - Test the fix
   - Commit the changes

---

## 🧪 Testing the Workflow Locally

Before pushing, you can test locally:

```bash
# Test the export command
./scripts/test_export.sh

# If it works locally but fails in CI, it's likely:
# - Missing files in git
# - Environment differences
# - Permission issues
```

---

## 📊 Understanding the Workflow

### What happens on push to `main`:

```
1. GitHub detects push
2. Starts Ubuntu container
3. Pulls godot-ci:4.4 Docker image
4. Checks out your code
5. Sets up Godot export templates
6. Runs: godot --export-release "Web" build/web/index.html
7. Uploads artifact (for download)
8. Installs rsync
9. Pushes to gh-pages branch
10. GitHub Pages rebuilds and deploys
```

### What happens on push to `claude/*`:

```
1-7. Same as above
8. STOPS - doesn't deploy anywhere
9. Artifact available for download in Actions tab
```

---

## 🎯 Quick Troubleshooting Checklist

When build fails, check:

- [ ] Export preset named exactly "Web" in `export_presets.cfg`
- [ ] All `.tscn` files committed to git
- [ ] `project.godot` has valid paths
- [ ] GitHub Actions has write permissions
- [ ] Godot version matches (4.4)
- [ ] No large files blocking git
- [ ] Main scene exists at specified path

---

## 🚨 Real-Time Monitoring

Watch your workflow in real-time:

```bash
# Using GitHub CLI
gh run watch

# Or watch in browser
# https://github.com/divineforge/mini-card-rpg/actions
# (it auto-refreshes)
```

---

## 💡 Pro Tips

1. **Always check the full logs:** Scroll up from the error, sometimes the real issue is earlier

2. **Test locally first:** Run `./scripts/test_export.sh` before pushing

3. **Use workflow_dispatch:** Manually trigger workflows to test without pushing

4. **Check the Actions tab often:** Failed builds won't show in main repo view

5. **Enable email notifications:** Get alerts immediately when builds fail

---

## 🆘 Getting Help

If you're stuck:

1. **Check this guide** for common errors
2. **Read the full error log** (not just the summary)
3. **Share the error with me** - I can fix it!
4. **Check GitHub Actions docs:** https://docs.github.com/en/actions

---

## Current Status

Your workflow is configured correctly! ✅

Potential issues I've already fixed:
- ✅ Export preset name matches
- ✅ Build path corrected
- ✅ Container version matches Godot version
- ✅ Proper permissions in workflow

When you merge to main, it should work! But if it doesn't, just share the error and I'll fix it immediately. 🚀
