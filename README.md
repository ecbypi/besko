# Besko Package Mailer

A hobby project to improve on package delivery at my now-defunct college dorm.

For an explanation of the functionality of the application, see
[PURPOSE.md](PURPOSE.md)


## Setup

Setup requires having [homebrew](https://brew.sh) installed.

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

Next, run the setup script.  You'll be prompted for information to create your
account in the local database for testing.

```shell
./bin/setup
```

[`rbenv`]: https://github.com/rbenv/rbenv


## Running Tests

Check that everything is setup and working by running the test suite:

```shell
bundle exec rspec
```
