# Besko Package Mailer

A hobby project to improve on package delivery at my now-defunct college dorm.

For an explanation of the functionality of the application, see
[PURPOSE.md](PURPOSE.md)


## Setup

### Clone the Repository

Clone the repository to your local machine.

```shell
git clone git@github.com:ecbypi/besko
```


### Ruby and the Gems

Using your ruby version manager of choice ([`rbenv`] is recommended), use
[`.ruby-version`](.ruby-version) to install the current version of ruby.

```shell
rbenv install
```

Next, run the setup script:

```shell
./bin/setup
```

[`rbenv`]: https://github.com/rbenv/rbenv


## Running Tests

Check that everything is setup and working by running the test suite:

```shell
bundle exec rspec
```
