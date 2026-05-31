# 1. Pull the remote changes first
git pull origin main

# 2. Check what's actually in your folder
ls assets   # or: ls Assets

# 3. Stage everything you want (use the correct casing)
git add Assets/
# OR if you want to add everything untracked at once:
git add .

# 4. Commit
git commit -m "Add assets and project files"

# 5. Push
git push origin main