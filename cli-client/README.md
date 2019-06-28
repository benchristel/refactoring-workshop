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

Each section below contains a user story and some follow-up
questions.

## The Cabbages API

### User Story

As a Python developer
I want to be able to call the Cabbages API via OC2RTA
So that I can obtain information about cabbages

**Given** I have OC2RTA installed and on my `$PATH` as `oc`
**And** I have imported the OC2RTA library into my program with `import oc`
**When** I call the function `oc.cabbages()`
**Then** I receive information about cabbages

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
dictates that developer workstations not have access to
the cabbages API. You will therefore not have the opportunity
to test your code on real cabbages before its first release.
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

## Authentication

### User Story

It turns out there's more to the Cabbages API than you
thought! If you authenticate with the API by providing a
username and password, it shows you additional, secret
cabbages!

**Given** I have OC2RTA installed and on my `$PATH` as `oc`
**And** I have imported the OC2RTA library into my program with `import oc`
**When** I provide a username and password to the cabbages function
**Then** they are passed along to `oc`, like: `oc cabbages --username alice --password t0ps3cret`

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
- How can you test your code to make sure all these weird
  edge cases are handled? Try it.
- If you could change one thing about the programming
  language or operating system to make this story easier to
  implement, what would it be? What other problems might
  that change cause?
