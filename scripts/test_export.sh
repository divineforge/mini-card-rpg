#!/bin/bash

# Local Web Export Test Script
# This script helps you test the web export before pushing to GitHub

set -e

echo "🎮 Testing Godot Web Export..."
echo ""

# Check if Godot is installed
if ! command -v godot &> /dev/null && ! command -v godot4 &> /dev/null; then
    echo "❌ Godot not found in PATH"
    echo "Please install Godot 4.4 or add it to your PATH"
    echo ""
    echo "Download from: https://godotengine.org/download"
    exit 1
fi

# Use godot4 if available, otherwise godot
GODOT_CMD="godot"
if command -v godot4 &> /dev/null; then
    GODOT_CMD="godot4"
fi

echo "✅ Found Godot: $GODOT_CMD"
echo ""

# Create build directory
mkdir -p builds/web
echo "📁 Created builds/web directory"

# Export the project
echo "🔨 Exporting web build..."
$GODOT_CMD --headless --export-release "Web" builds/web/index.html

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Build successful!"
    echo ""
    echo "📦 Build location: builds/web/"
    echo ""
    echo "🌐 To test locally, run:"
    echo "   cd builds/web && python3 -m http.server 8000"
    echo ""
    echo "Then open: http://localhost:8000"
else
    echo ""
    echo "❌ Build failed!"
    echo "Check the error messages above."
    exit 1
fi
