## Contributing

In the spirit of [free software][free-sw], **everyone** is encouraged to help
improve this project.

[free-sw]: http://www.fsf.org/licensing/essays/free-sw.html

Here are some ways *you* can contribute:

* by using alpha, beta, and prerelease versions
* by triaging bug reports
* by writing or editing documentation
* by writing specifications
* by writing code (**no patch is too small**: fix typos, add comments, clean up
  inconsistent whitespace)
* by refactoring code
* by fixing [issues][]
* by reviewing patches
* by suggesting new features
* [financially][gittip]

[issues]: https://github.com/sferik/rails_admin/issues
[gittip]: https://www.gittip.com/sferik/

## Getting Help

We use a [mailing list][list] for user support. If you've got a "how do
I do this?" or "this doesn't seem to work the way I expect" type of
issue or just want some help, please post a message to the [mailing
list][list].

## Submitting an Issue

If you're confident that you've found a bug in
rails_admin, please [open an issue][issues], but check to make sure it hasn't
already been submitted. When submitting a bug report, please include a
[Gist][] that includes a stack trace and any details that may be
necessary to reproduce the bug, including your gem version, Ruby
version, and operating system.  Ideally, a bug report should include a
pull request with failing specs.

[gist]: https://gist.github.com/
[list]: http://groups.google.com/group/rails_admin

## Submitting a Pull Request
1. [Fork the repository.][fork]
2. [Create a topic branch.][branch]
3. Add specs for your unimplemented feature or bug fix.
4. Run `bundle exec rake spec`. If your specs pass, return to step 3.
5. Implement your feature or bug fix.
6. Run `bundle exec rake spec`. If your specs fail, return to step 5.
7. Run `open coverage/index.html`. If your changes are not completely covered
   by your tests, return to step 3.
8. Add, commit, and push your changes.
9. [Submit a pull request.][pr]

[fork]: http://help.github.com/fork-a-repo/
[branch]: http://learn.github.com/p/branching.html
[pr]: http://help.github.com/send-pull-requests/
