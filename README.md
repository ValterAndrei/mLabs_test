## Parking Manager

![Rails Tests](https://github.com/ValterAndrei/mLabs_test/workflows/Rails%20Tests/badge.svg)
<a href="https://codeclimate.com/github/ValterAndrei/mLabs_test/maintainability"><img src="https://api.codeclimate.com/v1/badges/db3aeff20875aeb0b636/maintainability" /></a>

1. Build image
```
docker-compose build
```

2. Access bash
```
docker-compose run --rm web bash
```

3. Install dependencies
```
bundle
```

4. Setup database
```
rails db:setup
```

5. Tests
```
rspec
```

6. Linter/Formatter
```
rubocop
```

7. Run project
```
docker-compose up web
```

8. Restore production database
```
$ ./import_db_from_heroku.sh
```

---

### Run with debug in VSCode

1. Install extension _Ruby_
```
ext install rebornix.Ruby
```

2. Up the project
```
docker-compose -f docker-compose.yml -f docker-compose.debug.yml up
```

3. Press F5 to execute _launch.json_

---

### Run with byebug

1. Up the project
```
docker-compose run --rm --service-ports web
```

### Front-end
See [Parking Manager Front](https://github.com/ValterAndrei/parking_manager_front/).


### Production
[On heroku](https://parking-manager-front.herokuapp.com/)

---

### Deploy
```
git remote add heroku https://git.heroku.com/parking-manager-back.git

git push heroku main
```
