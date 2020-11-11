## mLabs

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

4. Tests
```
rspec
```

5. Linter/Formatter
```
rubocop
```

6. Run project
```
docker-compose up web
```
