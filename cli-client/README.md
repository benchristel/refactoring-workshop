# CLI Client

Your company, CyberFarm International, has developed a
command-line interface (CLI) tool named The One CLI To Rule
Them All (or OC2RTA, pronounced "octurta"). It allows
employees to perform a wide variety of tasks by sending
requests to various HTTP APIs that exist within the
company's internal network.

Now, the tasks that humans once performed using OC2RTA need
to be automated. Your job is to develop a client library for
OC2RTA using Python. The library will allow programs written
in Python to use OC2RTA features without directly shelling
out, forking processes, etc.

## About This Kata

Each section below contains a user story and some follow-up
questions. Once you are "done" implementing the story you
should answer the follow-up questions. If you don't like the
answers you're giving, improve your code until you do like
them.

## The Cabbages API

### User Story

- As a Python developer
- I want to be able to call the Cabbages API via OC2RTA
- So that I can automate tasks that need to know about cabbages

- **Given** I have OC2RTA installed and on my `$PATH` as `oc`
- **And** I have imported the OC2RTA library into my program with `import oc`
- **When** I call the function `oc.cabbages()`
- **Then** I receive information about cabbages

### Implementation Notes

The way OC2RTA currently works is that if you run `oc cabbages`
you receive a list of cabbages structured as JSON on
standard output, like:

```
{
  "cabbages": [
    {"id": "1", "weight": 20},
    {"id": "2", "weight": 32},
    {"id": "3", "weight": 13}
  ]
}
```

You are free to decide how to structure the data you return
to the caller. Use your best judgement.

To prevent over-straining the API servers, company policy
dictates that your workstation not have access to the
cabbages API. You will therefore not have the opportunity to
test your code on real cabbages before its first release.
Adjust your testing strategy appropriately.

### Follow-up questions

- How much confidence do your tests (if any) give you that
your code is actually correct? Can you do anything to
increase that confidence?
- If you could change one thing about the requirements of this
story to make it easier to implement, what would it be?
- How easy will it be to adjust your code if more cabbage
properties are added in the future?
- How easy will it be for developers who use your library to
test code that calls it?
- Recall that developers do not have access to the Cabbages
API and are not likely to be familiar with its details. How
self-documenting is your code, for these developers? Can
tests help your codebase be more self-documenting?
- Describe two tradeoffs that you made while choosing a
course of implementation.
- Are there any untested parts of your code? Is it worth
  testing them?
- Do you have any tests that aren't worth their likely
  maintenance costs?

## Authentication

It turns out there's more to the Cabbages API than you
thought! If you authenticate with the API by providing a
username and password, it shows you additional, secret
cabbages!

### User Story

- **Given** I have OC2RTA installed and on my `$PATH` as `oc`
- **And** I have imported the OC2RTA library into my program with `import oc`
- **And** I have a file named `~/.ocrc` that exports my username and password
- **When** I call `oc.cabbages()`
- **Then** my credentials are passed along to `oc`, like: `oc cabbages --username alice --password t0ps3cret`

### Implementation Notes

User research reveals that the username and password for
OC2RTA are always stored in a file named `~/.ocrc`, which is
typically sourced into the user's shell environment. The
file looks like this:

```
export OC2RTA_USERNAME=alice
export OC2RTA_PASSWORD=t0ps3cret
```

You can get the username and password from this file.
You cannot assume, however, that the `OC2RTA_USERNAME` and
`OC2RTA_PASSWORD` variables are already present in your
program's environment.

### Follow-up questions

- What happens if a user's password contains spaces?
- What happens if a user's password contains a dollar sign?
- What happens if a user's password contains backticks?
  (e.g. \`hi\`)
- What happens if a user's password starts with a hyphen?
  (Note that arguments that start with hyphens are treated
  as special flags by `oc`, e.g. `--password`)
- What happens if a user's password contains quotes?
- The `~/.ocrc` file can contain arbitrary shell code.
  If the file contains more lines than just the username
  and password exports, does your code account for that?
- What happens if the crucial lines in the `~/.ocrc` file
  are split with escaped newlines, e.g.

  ```bash
  export OC2RTA_PASSWORD=\
  "someone's really long password"
  ```

- Is your code tested in a way that ensures all these weird
  edge cases are handled?
- How confident are you that there aren't *more* weird edge
  cases you haven't considered?
- Describe three ways of getting the username and password
  out of the file. What are the pros and cons of each?
- How easy will it be for future maintainers of your library
  to understand the implementation?
- How easy will it be for developers who use your library to
  test code that calls it?
- How confident are you that your code is correct? What
  could you change to increase that confidence?
- Test frameworks often run tests in parallel to cut down
  on test run times. Could all your tests run in parallel?
  Why or why not?
- Describe two tradeoffs that you made while choosing a
  course of implementation.
- If you could change one thing about the programming
  language or operating system to make this story easier to
  implement, what would it be? What other problems might
  that change cause?
- The story and notes hint at the possibility
  of an alternative implementation that might be much
  easier, if you could confirm that it worked. What is it?
- What are some security issues with this method of
  authentication? Is there anything you can do to mitigate
  them?

## Authentication 2.0

Your library now needs to work in an environment that doesn't
have an `~/.ocrc` file (surprise!) The `cabbages()` function
should optionally accept the username and password as
parameters.

### User Story

- **When** I pass a username and password to the cabbages function
- **Then** they are passed along to `oc`, like: `oc cabbages --username alice --password t0ps3cret`

- **When** I call `cabbages` without passing a username and password
- **Then** it should get the credentials from the `~/.ocrc` file

- **Given** There is no `~/.ocrc` file on my computer
- **When** I call `cabbages` without passing a username and password
- **Then** it should not pass the `--username` and `--password` flags to `oc`.

### Follow-up questions

- Will it be easy to add more parameters to the `cabbages`
  function in the future? Will developers who call `cabbages`
  have to update their code when new parameters are added?
  Why or why not?
- Are you correctly accounting for special characters in
  the input (dollar, space, backticks, etc.)?
- Is there any duplication in your code? If so, what
  problems might it cause later?
- How easy will it be for developers who use your library to
  test code that calls it?
- How confident are you that your code is correct? What
  could you change to increase that confidence?
- Describe two tradeoffs that you made while choosing a
  course of implementation.

## More APIs

Python developers are pleased that they can now access
cabbages, but they want more! Your PM hands you the
following list of nonsensical commands that your library
must wrap, with a promise that many, many more are coming.

| **OC Command** | **Flag** | **Flag Takes Argument?** | **Flag Required?** | **Example**
| -------------- | -------- | ------------------------ | ------------------ | -----------
| **`oc sprinklers`** | `--region` | yes | yes | `oc sprinklers -k --region ca`
| | `-k` | no | no
| | `-d` | no | no
| **`oc set-sprinkler`** | `--on` | no | no | `oc set-sprinkler --on --id`
| | `--off` | no | no
| | `--id` | yes | yes
| **`oc pull`** | `--insecure` | no | no | `oc pull --leaf 32f8a90`
| | `--leaf` | yes | no

You decide that you don't want to set yourself up for more
work in the future than absolutely necessary. Can you
implement your PM's request in a way that makes future
stories in this vein trivially easy?

Your implementation must satisfy the following:

- There should be one function in the library per `oc`
  command.
- Each function should take parameters corresponding to the
  `oc` flags.
- You can assume that all arguments to the flags are strings
- If the caller of a function doesn't pass a required flag
 or argument, you should throw an error.
- If your caller doesn't pass an optional argument, you
  should not pass the corresponding flag to the `oc`
  command.
- Each command returns JSON on standard output, which you
  should pass back to the caller of your library. The shape
  of the JSON isn't documented anywhere, though.
- If a username and password are available (in the `~/.ocrc`
  file or passed to the function), they should be passed
  along to `oc` as they were for the `cabbages` API.

## Logging

Developers like your library, but they would like to be able
to have a log of the exact `oc` commands it executes. This
will enable them to debug their programs more easily.

### User Story

- As a Python developer
- I want to have a log of the shell commands executed by the
  `oc` library
- So that I can debug my programs more easily

- **Given** I have configured logging (i.e. specified where
  to write the logs)
- **And** I have called functions in the `oc` module
- **When** I look at the logfile
- **Then** I see the exact shell commands that were
  executed, formatted so I can copy-paste them into my
  terminal and they will work.

- **Given** I have *not* configured logging
- **Then** no logs will be written.

### Follow-up Questions

- How much work do developers have to do to add logging to
  their programs?
- What happens if different parts of a program want to log
  to different files? How could you change your API to
  accommodate this, while maintaining backwards
  compatibility? How can you make it easy to later remove
  the old API?
- What are the security risks to logging? How could you
- mitigate them?
- How easy is it for developers to test code that calls your
  library?
- Did you add conditional statements to your code when
  implementing this story? If so, can you refactor to
  make them unnecessary?
- How simple is your test setup/teardown? Can you run all
  your tests in parallel?
- Is writing to the log threadsafe? Why or why not?
- Describe a tradeoff you made while implementing this
  feature.
- Describe an assumption you made about the developers who
  will use your library.

## Password Redaction

Users of software written using your library are worried
about their passwords being logged. You now need to modify
your logging code to strip passwords out of the logs.

- As a user of software that calls `oc`
- I do not want my password to be logged
- So that it stays secret and my data is secure

- **Given** I have configured logging
- **And** I have called functions in the `oc` module,
  providing a username and password (either through the
  function arguments or a file)
- **When** I look at the logs
- **Then** I see a generic string like `xxxx` in place of my
  password.

### Follow-up Questions

- Is there any duplication in your code?
- Is there any way your redaction logic could inadvertently
  *reveal* some users' passwords?

## Logging to STDOUT

Developers are asking for a more flexible logging solution.
They want to see `oc` commands logged to stdout so they can
more easily debug failures in their Concourse pipelines.

They have additionally asked for password redaction to be
turned OFF when logging to STDOUT.

### User Story

- **Given** I have configured logs to go to STDOUT
- **When** I call a function in the `oc` module
- **Then** I see the command printed to STDOUT
- **And** if I provided a password, it appears in the output.

### Follow-up Questions

- Unix treats STDOUT similarly to an ordinary writable file;
  e.g. you write to it using a file descriptor. How can this
  feature of Unix help you implement this story?
- How much confidence do your tests give you that this
  feature is working?
- Could this change possibly break any clients of your
  logging API?
- If you could go back in time and redesign your original
  logging API, what would you change?
- Are the various responsibilities of your library cleanly
  separated? Does each piece have only one reason to change?
