# GOV.UK Chat

A chat bot style user interface prototype.

### Before running the app

```bash
cp dotenv.sample .env # then add your params
bundle install
rails db:create
rails db:migrate
```

### Running the app

```bash
rails s
```

### Running the test suite

Currently, there are no tests for this application. However, the following will work when tests have been added.

```bash
bundle exec rake
```

## Licence

[MIT Licence](LICENCE.txt)
