#!/bin/bash

# Backup the file
cp /codes/src/basic-auth.js /codes/src/basic-auth.js_backup

# Perform the substitution using a different delimiter
sed -i 's/\${hashed_username}/BPiZbadjt6lpsQKO4wB1aerzpjVIbdqyEdUSyFud+Ps=/g' /codes/src/basic-auth.js
sed -i 's/\${hashed_password}/XohImNooBHFR0OVvjcYpJ3NgPQ1qq73WKhHvch0VQtg=/g' /codes/src/basic-auth.js

# Run npm test
npx mocha

# Revert the changes
mv /codes/src/basic-auth.js_backup /codes/src/basic-auth.js
