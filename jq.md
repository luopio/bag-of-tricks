## Filter only all dumped models where 1,2 or 3 is the admin
python manage.py dumpdata schools.School --indent 2 | jq "[.[] | select(.fields.admins | index(1,2,3))]"

## Filter all forms where the school is 1,2,3
python manage.py dumpdata schools.Form --indent 2 | jq "[.[] | select(.fields.school == (1,2,3))]"

