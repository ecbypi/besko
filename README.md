# Besko Package Mailer

A hobby project to improve on broken processes at my old dormitory.

[![Travis CI](http://img.shields.io/travis/ecbypi/besko.svg)](https://travis-ci.org/ecbypi/besko)
[![Code Climate](https://img.shields.io/codeclimate/github/ecbypi/besko.svg)](https://codeclimate.com/github/ecbypi/besko)
[![Code Climate Coverage](http://img.shields.io/codeclimate/coverage/github/ecbypi/besko.svg)](https://codeclimate.com/github/ecbypi/besko)

For an explanation of the functionality of the application, see [PURPOSE.md](PURPOSE.md)

## Setup

The following setup assumes you have the version of ruby specified in the
`Gemfile` and the `bundler` gem installed. The
[`rbenv`](https://github.com/sstephenson/rbenv) ruby manager is recommended.

### Installation

Clone the project from GitHub:

```shell
$ git clone https://github.com/ecbypi/besko
```

Then bundle to install the application's dependencies:

```shell
$ bundle install
```

System dependencies include:

* mysql
* redis
* memcached

To install these, install [`homebrew`](http://brew.sh/) and run `brew bundle`
from the root of the project directory. This will install the dependencies
listed in the `Brewfile`. If additional system dependencies are needed, add
them there.

## Running Tests

Since tests have their `ENV` variables stubbed in `spec/spec_helper.rb`, only
`bundle exec` is needed to run tests:

```shell
$ bundle exec rspec [path/to/spec]
```
