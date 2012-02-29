# besko package mailer

This application was a hobby project I worked on while at MIT for my dorm to
replace a terrible paradigm of doing things for one that's easier and better.

The old way of doing things:
* Look up recipients one at a time on the horrible directory search on `web.mit.edu`
* Add emails one by one
* Check for duplicate emails and update the body of the email to indicate that
  person got more than one package
* Send your email, leaving your sent message as a log that the package was received


The new way of doing things:
* Type in the name on the package
* Click on you typed in when it appears
* Add some package details (how many, who delivered it)
* Send notifications, recipients are automatically notified
* Packages are logged for everyone's use
* Emails are sent individually to each resident to help maintain some form of privacy

This isn't the current code that's running in production, but a rewrite I
decided to do with better practices and incorporating what I've learned working
professionally with Rails over the past year. The old site (that unfortunately is still up)
was written without tests and without proper planning of features so it became a mess of
ActiveRecord models and broken `remote: true` AJAX calls. I started writing
tests to work on fixing functionality, but everything was such a tangled mess it was
easier to build from scratch (and more fun).

## why is this here?

I decided to put this here as an example of a non-standard Rails app to demo
some common and uncommon functionality/practices like:

* Backbone
* Authententication using Touchstone (MIT's internal deployment Shibboleth)
  headers (mostly configured via Apache)
* Authentication via LDAP (still considering)
* Cucumber/Rspec to drive development
* More as time passes and integrate more for the dorm's benefit

Anyone intersted in Rails can take a peek and hopefully learn something (or
help me learn something).
