Want to get started extending and improving RailsAdmin?  Great!  If you feel ready to just dive in and get started, have at it!  However if you'd like a little rundown of how the library works, including the major components and techniques for painlessly building on to the RailsAdmin code, this guide should help you get acquainted.

## Major Concepts

RailsAdmin is extremely quick and easy to use because it attempts to intelligently determine as much as it possibly can about your application's model (your DB schema) without needing explicit instructions.  In many cases, the system's guesses are good enough to do the job without further customization.  However some apps (or sometimes certain critical models within your app) require more administrative functionality than basic CRUD operations available through the stock RailsAdmin install.

Luckily, the code is well thought out and easy to build upon once you understand how it works.  Here are some things you should know about RailsAdmin's basic design:

