## The Problem

At MIT, students used to work the front desk. One of their roles was to sign for
packages and notify residents.

Prior to this application, the steps for notifying a resident they received a
package was:

* Look up recipients one at a time using the directory search on `web.mit.edu`,
  adding their email addresses one by one.
* Do your own research if a name on a package wasn't found in the directory.
  This typically happened because residents wouldn't use their full, legal name
  that was used in the directory (i.e. Julie vs Julia).
* Check for duplicate emails and update the body of the email to indicate that
  person got more than one package.
* Send your email, leaving your sent message as the only log that the package
  was received.
* Sometimes the desk worker would create and fill out a paper log. Not all desk
  workers would use the paper log or it would get filled out and no one would
  print a new one.

The biggest problem with this process was the lack of a record for residents to
check. If a resident could not find their package, and a different worker than
the one who received it was working the front desk, the resident would have to
dig through emails to find out who sent the email and track them down in the
building.


## The Solution

The Besko app used the MIT LDAP server to perform searches not possible on
`web.mit.edu`. Search results are shown in an autocomplete list with additional
context like email and assigned building on campus.

When a package is logged for a resident, an account is created for them to view
the delivery log and acknowledge receipt of the package. Signing in leverages
MIT's single-sign-on service.

Delivery logs track:
* Who received it and their email address
* Number of packages in the delivery
* What delivery company or group delivered the package
* Time of receipt

In some cases, packages are not put away after being logged. Desk workers have
a special view to look at delivery history to check if packages have already
been logged and to assist residents who may have questions about their package.
