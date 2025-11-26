#!/bin/bash
set -e
cd "$(dirname "$0")"

# Initialize git if needed
if [ ! -d .git ]; then
    echo "Initializing git repository..."
    git init
    git remote add origin https://github.com/RIKTIGATOMTEN/CoreBot-Docs.git
    git branch -M main
fi

# Create .gitignore if it doesn't exist
if [ ! -f .gitignore ]; then
    echo "Creating .gitignore..."
    cat > .gitignore << EOF
node_modules/
.vitepress/dist
.vitepress/cache
EOF
fi

# Push source code to main
echo "Pushing source code to main..."
git add .
git commit -m "Update documentation source" || echo "No changes to commit"
git push -f origin main

# Build the site
echo "Building VitePress site..."
rm -rf .vitepress/dist
npx vitepress build

# Deploy to gh-pages branch
echo "Deploying to gh-pages..."
cd .vitepress/dist
git init
git remote add origin https://github.com/RIKTIGATOMTEN/CoreBot-Docs.git
git add .
git commit -m "Deploy latest VitePress build"
git branch -M gh-pages
git push -f origin gh-pages

cd ../..
echo "Deployment complete!"
echo "Source pushed to main, build deployed to gh-pages"
echo "Site should be live at: https://riktigatomten.github.io/CoreBot-Docs/"