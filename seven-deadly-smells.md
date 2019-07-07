# The Seven Deadly Smells

Refactoring works best when guided by a knowledge of _code
smells_. Code smells are harmful patterns that often accrete
in code as it changes. The presence of a code smell
typically means that the code *may* be difficult or risky to
change later.

If you've never heard of code smells, take a few minutes to
read Jeff Atwood's [blog post](https://blog.codinghorror.com/code-smells/) listing about 30 of them. [The Wikipedia article on code smells](https://en.wikipedia.org/wiki/Code_smell) also has a few that aren't on Jeff's list.

I like the concept of code smells because it gives us
programmers a shared set of terms for talking about
problems in our code. However, the smells are just
heuristics. Code that seems smelly may actually be harmless.
It takes a lot of experience to tell the difference between
a benign code smell and a malignant one.

For instance, are _long methods_ really a smell? In many
cases they are. But sometimes it's easier to read a long
method than trace the execution path through a bunch of
small ones. Knowing when to remove the smell and when not
to is something of a dark art.

Additionally, a lot of the smells have a "mirror image"
counterpart. For instance, classes that are too large
are a smell, but so are classes that are too small! If
you're refactoring away from one of these smells, it takes a
good deal of judgement to know when to stop. I've seen teams
obsessively refactor away one code smell only to produce its
equally-harmful opposite.

It would be nice if we could have a more objective set of
criteria for knowing when to refactor. Can we discover a set
of code smells that don't rely on opinion, and that can be
safely refactored away without the help of arcane wisdom?
Can we find smells that aren't merely hints, but sure
signs that something is wrong?

I believe we can. Below I present seven code smells, some
of which clarify items on Jeff's list, and some of which
are wholly new. These smells do not have "mirror images",
so the refactorings they exhort are nearly always a good
idea.

The smells are in priority order, from worst and easiest
to fix to least harmful and hardest to fix.

# Casual Mutation

## The Smell

Imagine this: you're reading some code, and you want to know
what a particular method will return. So you crack open its implementation
and take a look:

```java
    // ...

    return result;
}
```

Great. Where's `result` assigned? You start reading from the
top of the method.

```java
public Result doSomething(Object... params) {
    Result result = buildDefault(params);

    // ...
}
```

So is that the answer? Can we conclude that this method
returns whatever `buildDefault` returns? In general, we can't,
because `result` might be reassigned somewhere in
the middle of the method. We have to read the whole method,
hunting for occurrences of `result`, before we can
even begin to understand what its final value will be.

## The Fix

The solution is simple, at least in Java and JavaScript:
declare all variables `final` or `const`. Any mutable
variables should have a clear reason to mutate: for
instance, the index variable in a `for` loop.

If you need to build up a result from a sequence of several
computations, there are cleaner alternatives to mutation:

- A functional pipeline:
  ```java
  return myList.stream()
    .map(x -> x + 1)
    .filter(x -> x % 2 == 0)
    .sum();
  ```

- A chain of method calls:
  ```java
  return new BigInt(n)
    .pow(r + 1)
    .plus(k);
  ```

- Composed functions:
  ```java
  return reversed(lowercase(name));
  ```

You should also think twice before mutating objects like
lists and maps. Many languages have libraries of _persistent
data structures_, which efficiently represent immutable
values.

It's fine to have mutable objects, but the mutability
should be part of the core responsibility of the class, not
a hidden gotcha that will surprise other developers.

# Redundant State

## The Smell

Here's a Ruby class that downloads a file from the given URL
and lets you check up on the download progress:

```ruby
class Downloader
  def initialize(url)
    @url = url
    @percent_downloaded = 0.0
    @percent_remaining = 100.0
  end

  def percent_downloaded
    @percent_downloaded
  end

  def percent_remaining
    @percent_remaining
  end

  def start!
    # actually download stuff, and update the instance
    # variables in a background thread.
    # ...
  end
end
```

The instance variables `@percent_downloaded` and `@percent_remaining`
should always change together. `@percent_remaining` should
always be `100 - @percent_downloaded`.

What happens if one of these variables gets updated but
not the other? `Downloader` will give absurd results when
asked about the download progress. I'd rather not risk that.

## The Fix

We know `percent_remaining` will always be `100 - @percent_downloaded`,
so let's express that constraint in code:

```ruby
def percent_downloaded
  @percent_downloaded
end

def percent_remaining
  100 - @percent_downloaded
end
```

In general, it's better to store as little data as possible
and compute values on the fly rather than store multiple
sources of truth.

In more complex cases, you might worry about the performance
cost of recomputing values all the time. Keep in mind that
[computers are fast](https://computers-are-fast.github.io/).

# Deep Call Hierarchy

## The Smell

The Deep Call Hierarchy smell often manifests after repeated
application of the Extract Method refactoring. When this
smell is present, you see a bunch of small methods, each of
which does some work and delegates the rest to another
method. It doesn't take long before this delegation gets
very hard to follow. If you've ever felt the need to draw
out the call graph of a section of code on paper, you
probably had a Deep Hierarchy on your hands.

The Ruby methods below are involved in a Deep Hierarchy:

```ruby
def send_late_payment_reminders
  data = load_users()
  process(data)
end

def process(users)
  users.each do |user|
    p = LatePaymentProcessor.new(user)
    if p.needs_email_alert?
      send_email(user)
    end
  end
end

def send_email(data)
  email = construct_email(data)
  SMTP.send!(email)
end

def construct_email(data)
  # ...
end
```

## The Fix

The fix is superficially simple: inline all the methods and
extract new ones that are easier to understand. Use the
following guidelines to ensure that the Deep Hierarchy smell
won't return:

- Clearly separate codepaths that build or transform data
  values from codepaths that make system calls (e.g. reading
  from a database or sending messages to a server).
- Clearly divide application-agnostic "library" code from
  code that knows about the details of your application and
  business logic. Business-logic code may depend on "library"
  code but not the other way around.
- Keep the codepaths that make system calls especially shallow.
  Your top-level method should probably be calling library
  APIs directly.

Here's the refactored version of the example above—the
top-level method, anyway. Note that this method is doing its
work more directly than the top-level method in the smelly
example, and knows about more things. However, it's easy to
read, and the details of each step of the processing are
delegated to other classes. There are no mysteries in the
delegation: it's clear which responsibilities are delegated
and which are not.

```ruby
def send_late_payment_reminders
  users = Database.query(ListUsersQuery.new)
  now = Time.now
  users.filter { |user| user.payment_late?(now) }
    .map { |user| LatePaymentEmail.new(user) }
    .each { |email| SMTP.send!(email) }
end
```

# Switch on Type

## The Smell

TODO

## The Fix

TODO

# Null Check

> Complexity (in the bad sense) consists of distinctions
> which unnecessarily complicate a structure. To get
> simplicity, on the other hand, we need a process which
> questions every distinction. Any distinction which is not
> necessary is removed. To remove a distinction we replace
> it by a symmetry.
>
> —Christopher Alexander, _The Process of Creating Life_, p. 469

## The Smell

TODO

## The Fix

TODO

# Duplicated Control Flow

## The Smell

TODO

## The Fix

TODO

# Duplicated Boilerplate

## The Smell

Suppose we're writing a library that wraps an HTTP API.
Methods in this library make HTTP calls and return the
response data. There is a requirement that the library must
log every HTTP request it makes.

As you might imagine, the most likely structure for the library
is a class with a bunch of methods, each of which wraps a different
HTTP request.

Here's an example of what this class might look like in Ruby:

```ruby
class SomeLibraryName
  def get_users(params)
    request = UsersRequest.new(params)
    log(request)
    parse_json(request.response)
  end

  def get_products(params)
    request = ProductsRequest.new(params)
    log(request)
    parse_xml(request.response)
  end

  # ...
end
```

There is duplication in these methods,
but it is not obvious how to remove it. Here are the
duplicated parts of each method:

```
def           (params)
  request =              .new(params)
  log(request)
             (request.response)
end
```

and the parts that are different:

```
        get_users
               UsersRequest

  parse_json

        get_products
               ProductsRequest

  parse_xml
```

We call the parts that are the same [_boilerplate_](https://en.wikipedia.org/wiki/Boilerplate_code). They
are uninteresting plumbing; their purpose is just to tie together
the interesting bits.

This duplicated boilerplate can be harmful. If someone adds
a new method, they have to remember to call `log()`. If
they copy-paste an existing method, they have to remember to
change all the parts that vary between methods. If a change
needs to be made to all the existing methods, someone will
likely have to go through manually and edit each one. As the
methods get bigger and more numerous, these problems will
get worse.

## The Fix

The fix is brought to you by [Sandi
Metz](https://www.sandimetz.com/). Extract a new method that
parameterizes the parts of each API call that vary.

```ruby
def make_request(params, request_class:, parser:)
  request = request_class.new(params)
  log(request)
  parser.call(request.response)
end
```

Then we can call it in each API method:

```ruby
class SomeLibraryName
  def get_users(params)
    make_request(params,
      request_class: UsersRequest,
      parser: JsonParser)
  end

  def get_products(params)
    make_request(params,
      request_class: ProductsRequest,
      parser: XmlParser)
  end

  # ...
end
```

This reduces the boilerplate, though it's not fully eliminated.
Now only the call to `make_request` is duplicated. If we wanted
to, we could go even further and generate each API method
using metaprogramming, though I don't recommend doing this in Ruby
since it defeats the code analysis tools in your IDE.

One other problem with the refactored code as it stands is
that the API methods are [middlemen](http://wiki.c2.com/?MiddleMan): they just delegate their
work to `make_request`. This makes the call hierarchy deeper
than it needs to be, and we should avoid deep hierarchies.

In languages with good support for functional idioms, we can
fix this. For example, in JavaScript, we can flatten the
call hierarchy by generating the methods via a higher-order
function.

```javascript
const API = {
  getUsers: api(UsersRequest, parseJSON),
  getProducts: api(ProductsRequest, parseXML),
  // ...
}

function api(requestClass, parser) {
  return async function(params) {
    const request = requestClass(params)
    const response = await request.response()
    return parser(response)
  }
}
```
