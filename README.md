# Besko Package Mailer

[![Travis CI](http://img.shields.io/travis/ecbypi/besko.svg)](https://travis-ci.org/ecbypi/besko)
[![Code Climate](https://img.shields.io/codeclimate/github/ecbypi/besko.svg)](https://codeclimate.com/github/ecbypi/besko)
[![Code Climate Coverage](http://img.shields.io/codeclimate/coverage/github/ecbypi/besko.svg)](https://codeclimate.com/github/ecbypi/besko)

A hobby project to improve on many old processes at my old dormitory.

## The Problem

Prior to this application, the steps for notifying a resident they received a
package was:

* Look up recipients one at a time via the horrible directory search on `web.mit.edu`
  and add their email addresses one by one.
* Check for duplicate emails and update the body of the email to indicate that
  person got more than one package
* Send your email, leaving your sent message as a the only log that the package
  was received

The biggest problem this caused was that there would be no record to check if a
resident could not find thier package and a different worker than the one who
received it was working the front desk. The resident would have to dig through
emails to find out who sent the email and track them down in the building.

## The Solution

This site provides a way for desk workers to log packages effortlessly by using
the MIT LDAP directory to lookup users. Workers type in a name and select the
match from the autocompleted list of results. Each recipient has an account
created for them as their receive their first package, allowing them to review
relevant information about the delivery including:

* Who received it and their email address
* Number of packages in the delivery
* What delivery company or group delivered the package
* Time of receipt

In some cases, packages are not put away after being logged.  Desk workers have
a special view to look at delivery history to check if packages have already
been logged and to assist residents who may have questions about their package.

* Type in the name on the package
* Click on what you typed in when it appears
* Add some package details (how many, who delivered it)
* Send notifications, recipients are emailed automatically
* Packages are logged for desk workers' reviewal and recipients' records
* Emails are sent individually to each resident to help maintain some form of privacy

## Why is this here?

Anyone intersted in Rails can take a peek and hopefully learn something or
help me learn something. Some things to look for are:

* Authententication using Touchstone headers (mostly configured via Apache).
* Rspec to drive development.

## Future Plans

Logging packages wasn't the only problem to solve at the dorm. Some unsolved issues are:
* The groups that permissions fall into are closely tied to mailing lists.
  Updating the permissions should update the mailing lists or permissions
  should check the mailing lists.
* People forwarding mail that arrives for alumni relabel all the mail one by one. The
  system for creating deliveries can be abstracted to handle printing labels with the
  correct addresses on them.
* The desk captain has to manually log all the hours at the end of each week
  and hours are logged into a notebook at the front desk.
