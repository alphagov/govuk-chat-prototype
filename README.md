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

### Running the CSV exports locally

First run this to login and create a local credentials file...

```shell
gcloud auth application-default login
```

Then you can run the exports like this...

```shell
rails db:export_chat
rails db:export_feedback
rails db:export # Exports both chat and feedback
```

Alternatively, you can change the schedule (see [fugit](https://github.com/floraison/fugit) for ways to do this) in `config/schedule.yml` then start `sidekiq`...

```bash
bundle exec sidekiq
```

And wait! The `db:export` task will be queued and run automatically.

## Deploying both `app.yaml` and `worker.yaml`

```bash
gcloud app deploy app.yaml worker.yaml
```

## Licence

[MIT Licence](LICENCE.txt)
