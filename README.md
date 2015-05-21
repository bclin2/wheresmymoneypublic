# wheresmymoney
Phase 3 Final Project

##Summary

There's $41 billion in unclaimed property in the US. A typical scenario of unclaimed property is when a check is sent in your name to a wrong address and thus is never cashed. That money doesn’t go away; it goes into a government fund waiting until you actively claim it.

Common forms of unclaimed property include savings or checking accounts, stocks, uncashed dividends or payroll checks, refunds, and traveler's checks.

Most people have no idea they could have money waiting for them. Where's My Money aims to make it easier for all of us to access the money that’s rightfully ours.

##How it works

You can sign in through Google+ or search for results using the form below. If you sign in with Google+, you can see if your friends have money waiting for them as well. Once you have chosen possible hits, instructions will be went via email on how to claim your money.  

##Directions: Setting up on Linux Server

Make sure Redis is installed. Run the command ```foreman start``` to run the Procfile. It will generate workers and start up resque, resque-scheduler, and Redis. 