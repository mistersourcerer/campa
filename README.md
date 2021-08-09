# Campa

[![travis build (shildes.io) badge](https://img.shields.io/travis/com/mistersourcerer/campa?style=plastic "Build Status")](https://travis-ci.com/github/mistersourcerer/campa)
[![coverage (shildes.io) badge](https://img.shields.io/codeclimate/coverage/mistersourcerer/campa?style=plastic "Coverage Status")](https://codeclimate.com/github/mistersourcerer/campa)
[![gem version (shildes.io) badge](https://img.shields.io/gem/v/campa?include_prereleases&style=plastic "Version")](https://rubygems.org/gems/campa)
[![yard docs](http://img.shields.io/badge/yard-docs-blue.svg?style=plastic)](http://rubydoc.info/github/mistersourcerer/campa "Docs")

This is a [LISP](https://www.britannica.com/technology/LISP-computer-language) implementation written in Ruby.

[A versão PT-BR desse README está aqui.](README-PT_BR.md)

[![XKCD lisp cycles comic strip](https://imgs.xkcd.com/comics/lisp_cycles.png)](https://xkcd.com/297/)

It comes equiped with a [REPL](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop)
and a (very rudimentary) test framework.

You can install this gem normaly with:

    $ gem install campa

And after that the REPL can be run:

    $ campa

This will give you a prompt
where you can check if campa is working
by making an offer to the gods of programming:

    => (defun hello-world () (print "hello world"))
    (lambda () (print "hello world"))
    => (hello-world)
    "hello world"NIL

## What is this about?

Before going any further
you should probably know that,
as a LISP implementation,
this one is for sure on the EXTREMELY simple
side of the measuring device - whatever such a thing may be.

<img src="https://i.chzbgr.com/full/6819818496/h1DC5249B/measurement-fail" width="300" />

It's main purpose is to create room
for the author to learn about LISP
and language implementation.
So you should curb your enthusiasm while using/reading it.


### Paul Graham's The Roots of Lisp

There is this article by [Paul Graham](http://www.paulgraham.com/)
called [The Roots of Lisp](http://www.paulgraham.com/rootsoflisp.html).
As far as I can tell this is a seminal work
[that helped many people to understand LISP better](https://hn.algolia.com/?dateRange=all&page=0&prefix=false&query=%22roots%20of%20lisp%22&sort=byPopularity&type=story)
and maybe even made [the original McCarthy's ideas](https://crypto.stanford.edu/~blynn/lambda/lisp.html)
more accessible.

This project implements **LISP** to the point
where all the functions exemplified by Graham's article
run successfully. Which means one could implement *Campa* on itself
(or they could just [go here](../main/campa/core.cmp)
and see how it is done already).

## Usage

### Executing .cmp files

Let's say you have a *Campa* file `hello.cmp`
with the following code:

```lisp
(defun hello (stuff) (print "hello" stuff))
(label thing "Marvin")

(hello thing)
```

You can run this code
by using the *campa* executable like this:

    $ campa hello.cmp
    hello Marvin

Note that the functions *print* and *println*
are given "for free" to the user
in the sense that they are not specified in the *Roots of Lisp*.
But more on that later.

### Playing around in the REPL

Now if you want to play around with some ideas
before commit those to a file
(or version control, for that matter)
you can fire up the repl by typing _campa_:

    $ campa
    =>

The **=>** is the *REPL* prompt
and a sign that you can enter code now.

I will use this opportunity to show you
yet another function that comes with this implementation
but is not part of the *Roots of Lisp*.
Let's *load* the same file that was used on the previous example
in the current *REPL* session.

    => (load "./hello.cmp")
    hello  MarvinNIL

The **NIL** shown after the printed message
(hello Marvin) is the return of the *print* function itself.

Notice also that the function *hello*,
declared in the *hello.cmp* file,
is now available in the current *REPL* session.

    => (hello "World")
    hello  WorldNIL

## The Roots

The following functions are available
and considered the **core** of this LISP implementation.
They all have the expected behavior specified
in the aforementioned article [*The Roots of Lisp*](http://www.paulgraham.com/rootsoflisp.html).

```lisp
(atom thing)
(car list)
(cdr list)
(cond ((condition) some-value) ((other-condition) other-value))
(cons 'new-head '(list with stuffz))
(defun func-name (params, more-params) (do-something))
(eq 'meaning-of-life 42)
(label a-symbol 4,20)
(lambda (params, more-params) (do-something))
(list 'this 'creates 'a 'list 'with 'all 'given 'params)
(quote '(a b c))
```

Besides the actual functions
the notation that uses single quotation mark (')
to quote an object is also implemented in the runtime.

### Implementation details

All those functions are implemented in Ruby
[and they live right here](../3b43a21/lib/campa/lisp).

## Beyond the Roots

Some mentions were made in this very own Readme
about things that are available on *Campa*
but were not specified on *Roots of Lisp*.

Those are mainly functions and they come in two flavors:
the ones implemented on *Campa* itself
and the ones implemented on the runtime (in Ruby).

### Extras in Campa

  - [(assert x y)](../3b43a21/campa/test.cmp#L1)
    Returns **true** if x and y are *eq*

### Extras in Ruby (runtime)

  - [(load a-file another-file)](../3b43a21/lib/campa/core/load.rb)
    Read and evaluate the files given as arguments
  - [(print "some" "stuff" 4 '("even" "lists"))](../3b43a21/lib/campa/core/print.rb)
    Print out a human friendly representation of the given parameter(s)
  - [(println stuffz here)](../3b43a21/lib/campa/core/println.rb)
    Same as *print* but add a line break (`\n`) after each parameter

#### Tests

There is a very simplistic test framework
implemented in the runtime.
It is available via the *campa* command line
with the option **test**.
It receives as parameters files containing well...
tests.

The definition of a test in this context is any function
that starts with *test-* or *test_* (case insentive)
and return *true* for success
or *false* for failure.
The core implementation for *Campa* rely on this tool
and you can check out [some test examples here](../3b43a21/test/core_test.cmp).

    $ campa test test/core_test.cmp

    10 tests ran
    Success: none of those returned false

Internally this "framework" is comprised
of the two following functions:

  - [(tests-run optional-name other-optional-name)](../3b43a21/lib/campa/core/test.rb)
  - [(tests-report (tests-run))](../3b43a21/lib/campa/core/test_report.rb)

##### (tests-run)

The *tests-run* function will find
any function whose name starts with *test-* or *test_* (case insensitive)
in the current context and run it.
A function that returns *false*
is considered a failing test.

We can simulate this clearly in the REPL:

    $ campa
    => (defun test-one () "do nothing" false)
    (lambda () "do nothing" false)
    => (defun test-two () "great success" true)
    (lambda () "great success" true)
    => (tests-run)
    ((success (test-two)) (failures (test-one)))

This structure returned by *tests-run*
is well known by a second function...

##### (tests-report)

... we can use the *tests-report* function
to show a nice summary of tests ran:

    => (tests-report (tests-run))
    2 tests ran
    FAIL!
      1 tests failed
      they are:
        - test-one
    false

Notice that *tests-report* return *false* if there is a failure
or *true* if all tests pass.
This is an easy way to integrate this tool
with CI environments or any type of "progressive" build.

An example of how this is used by
*Campa* implementation [can be found here](../3b43a21/Rakefile#L12).


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mistersourcerer/campa.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
