#!/bin/bash

# Pre-flight Check Script
# Run this before pushing to catch common CI/CD issues

set -e

echo "🔍 Running pre-flight checks for GitHub Actions..."
echo ""

ERRORS=0
WARNINGS=0

# Check 1: Export preset exists and is named correctly
echo "✓ Checking export preset..."
if grep -q 'name="Web"' export_presets.cfg; then
    echo "  ✅ Export preset 'Web' found"
else
    echo "  ❌ ERROR: Export preset 'Web' not found in export_presets.cfg"
    ERRORS=$((ERRORS + 1))
fi

# Check 2: project.godot exists
echo ""
echo "✓ Checking project.godot..."
if [ -f "project.godot" ]; then
    echo "  ✅ project.godot exists"
else
    echo "  ❌ ERROR: project.godot not found"
    ERRORS=$((ERRORS + 1))
fi

# Check 3: Main scene is set
echo ""
echo "✓ Checking main scene..."
if grep -q "run/main_scene=" project.godot; then
    MAIN_SCENE=$(grep "run/main_scene=" project.godot | cut -d'"' -f2)
    echo "  ✅ Main scene set to: $MAIN_SCENE"
else
    echo "  ⚠️  WARNING: No main scene set in project.godot"
    WARNINGS=$((WARNINGS + 1))
fi

# Check 4: GitHub workflow exists
echo ""
echo "✓ Checking GitHub Actions workflow..."
if [ -f ".github/workflows/deploy.yml" ]; then
    echo "  ✅ Workflow file exists"
else
    echo "  ❌ ERROR: .github/workflows/deploy.yml not found"
    ERRORS=$((ERRORS + 1))
fi

# Check 5: Scripts directory
echo ""
echo "✓ Checking game scripts..."
SCRIPT_COUNT=$(find scripts/ -name "*.gd" 2>/dev/null | wc -l)
if [ $SCRIPT_COUNT -gt 0 ]; then
    echo "  ✅ Found $SCRIPT_COUNT GDScript files"
else
    echo "  ⚠️  WARNING: No .gd files found in scripts/"
    WARNINGS=$((WARNINGS + 1))
fi

# Check 6: Git status
echo ""
echo "✓ Checking git status..."
if [ -n "$(git status --porcelain)" ]; then
    echo "  ⚠️  WARNING: You have uncommitted changes"
    git status --short
    WARNINGS=$((WARNINGS + 1))
else
    echo "  ✅ Working directory clean"
fi

# Check 7: .gitignore includes build directories
echo ""
echo "✓ Checking .gitignore..."
if grep -q "builds/" .gitignore && grep -q "build/" .gitignore; then
    echo "  ✅ Build directories in .gitignore"
else
    echo "  ⚠️  WARNING: Build directories should be in .gitignore"
    WARNINGS=$((WARNINGS + 1))
fi

# Check 8: Large files
echo ""
echo "✓ Checking for large files..."
LARGE_FILES=$(find . -type f -size +10M 2>/dev/null | grep -v ".git" | grep -v "builds/" | grep -v "build/" || true)
if [ -z "$LARGE_FILES" ]; then
    echo "  ✅ No large files (>10MB) detected"
else
    echo "  ⚠️  WARNING: Large files found (may slow down CI/CD):"
    echo "$LARGE_FILES"
    WARNINGS=$((WARNINGS + 1))
fi

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo "✅ All checks passed! Safe to push."
    echo ""
    echo "Next steps:"
    echo "  git push origin main"
    echo ""
    echo "After pushing, check:"
    echo "  https://github.com/divineforge/mini-card-rpg/actions"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo "⚠️  $WARNINGS warning(s) found (safe to proceed)"
    echo ""
    echo "You can push, but review warnings above."
    exit 0
else
    echo "❌ $ERRORS error(s) found! Fix before pushing."
    echo ""
    echo "See errors above for details."
    exit 1
fi
