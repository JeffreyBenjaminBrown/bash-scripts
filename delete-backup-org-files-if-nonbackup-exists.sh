# Find all .org files in the directory and subdirectories
find . -type f -name "*.org" | while read org_file; do
  # Check if a file with the same name ending in ~ exists
  backup_file="${org_file}~"
  if [ -e "$backup_file" ]; then
    rm "$backup_file"
  fi
done
