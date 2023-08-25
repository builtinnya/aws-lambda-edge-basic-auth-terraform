#!/bin/bash

# Backup the file
cp src/basic-auth.js src/basic-auth.js_backup

# Perform the substitution using a different delimiter
sed -i '' 's/\${hashed_username}/BPiZbadjt6lpsQKO4wB1aerzpjVIbdqyEdUSyFud+Ps=/g' src/basic-auth.js
sed -i '' 's/\${hashed_password}/XohImNooBHFR0OVvjcYpJ3NgPQ1qq73WKhHvch0VQtg=/g' src/basic-auth.js

# Run npm test
npx mocha

# Revert the changes
mv src/basic-auth.js_backup src/basic-auth.js
