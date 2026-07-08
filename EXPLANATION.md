# How Functional BrainRuby works

## Numbers

Let's start with 1.

```ruby
[[]]<=>[]
#=> 1
```

We can add 1 incrementally like 1+1+1+1 to get anywhere, but that is inefficient. Let's instead use the `<<` operator to bitshift, building each binary digit.

```ruby
1 << 1
#=> 2
1 << 1 << 1
#=> 4
1 << 1 << 1 << 1
#=> 8
```

We can make any number by adding binary digits.

```ruby
(1 << 1) + (1 << 1 << 1) # == 2 + 4
#=> 6
```

Note this doesn't work without the parentheses, due to operator precedence. We'll solve this later.

```ruby
1 << 1 + 1 << 1 << 1 # == 1 << 2 << 1 << 1
#=> 16
```

We can build a string by shoveling numbers onto an empty string.

```ruby
"" << 101 << 118 << 97 << 108
#=> "eval"
```

Well, that might be useful...

## Lambdas

In Ruby, a lambda looks like this:

```ruby
my_func = -> (arg1, &block) {
  # some code that uses the arg and block
  arg1.map(&block)
}
```

We can then call it like this:

```ruby
my_func[[1,2,3]] { |i| i.to_s }
#=> ["1", "2", "3"]
```

We can use the shorthand symbol-to-proc syntax as well:

```ruby
my_func[[1,2,3], &:to_s]
#=> ["1", "2", "3"]
```

One neat thing to do with lambdas is to create an identity function (note this time we are omitting the optional argument parentheses):

```ruby
id_func = ->i{i}
id_func[1]
#=> 1
```

It might not seem too useful, but note for our purposes that it can entirely replace parentheses. Rather than wrapping in `()`, we can wrap in `id_func[]`. This kind of thing is very important when you are trying to ban characters from a language.

You can also pass a lambda to a lambda. For example:

```ruby
func2 = -> func1, arg {
  func1[arg]
}
func2[->i{i**2}, 4]
#=> 16
```

We can also pass a symbol-to-proc as an argument to the lambda, allowing us to use it inside the lamba as a callable proc! Consider this String method which takes an argument:

```ruby
12345.to_s(2)
#=> "11000000111001"
```

We convert to a string capturing the binary representation of the number. We can also accomplish this using lambdas:

```ruby
->&captured_to_s {
  captured_to_s[12345, 2]
}[&:to_s]
#=> "11000000111001"
```

What's happening? `:to_s` becomes a block, captured in `captured_to_s`. When called, the first argument becomes the method's receiver, and any other arguments become arguments to the method. So this is equivalent to calling `12345.to_s(2)`.

# Eval

Now let's apply all this to the `eval` method. We can capture it easily, but using it isn't simple.

If we want to create a language without alphanumeric characters, the strategy should be simple:

1. Use some means to create the string `eval`
2. Invoke the eval

We could try to capture it using a lambda, but what happens next?

Remember, we always need a receiver. So the first argument will be a simple empty string, and the next will be our code.

```ruby
->&captured_eval {
  captured_eval["", 'puts "hello world"']
}[&:eval]
# private method 'eval' called for an instance of String (NoMethodError)
```

Unfortunately, we can't just call `eval` on any old object. We have to use `send`. So, let's capture that instead.

```ruby
->&captured_send {
  captured_send["", "eval", 'puts "hello world"']
}[&:send]
hello world
=> nil
```

Success!

However, let's think about this more. We want a robust programming language. One which supports multiple files. Yet every time I run this code, it'll run in the context of a new string! Variables and functions set globally are prone to disappearing as I move to the next file. This won't do!

```ruby
->&captured_send {
  captured_send["", "eval", 'x = 4']
  captured_send["", "eval", 'puts x']
}[&:send]
# undefined local variable or method 'x' for an instance of String (NameError)
```

What I actually want is to run my code in the default Ruby context, represented by the built-in Ruby constant `TOPLEVEL_BINDING`.

```ruby
->&captured_send {
  captured_send[TOPLEVEL_BINDING, "eval", 'x = 4']
  captured_send[TOPLEVEL_BINDING, "eval", 'puts x']
}[&:send]
```

Perfect! However, this is lots and lots of alphanumerics. Let's get rid of them!

## String Obfuscation

First, let's recap where we are. We'll turn this into an ERB template, with `<%= @esocode %>` as the userland code to substitute. (Note that obfuscating that code is the easy part - just generating a string without alphanumerics. See the first section of this writeup!)

```erb
->&captured_send {
  captured_send[TOPLEVEL_BINDING, "eval", <%= @esocode %>]
}[&:send]
```

We've already done the hard part. Now the easy part: Turn everything into non-alphanumeric characters, or alphanumeric strings which we know how to obfuscate.

First, we'll turn `TOPLEVEL_BINDING` into a string. Remember, `TOPLEVEL_BINDING` is just a constant, so anywhere we `eval` the string `"TOPLEVEL_BINDING"` will get us the binding we need.

```erb
->&captured_send {
  captured_send[
    captured_send["", "eval", "TOPLEVEL_BINDING"],
    "eval",
    <%= @esocode %>
  ]
}[&:send]
```

Next, we'll deduplicate a bit, by extracting the shared string `"eval"`:

```erb
->&captured_send{
  ->captured_eval{
    captured_send[
      captured_send[
        "",
        captured_eval,
        "TOPLEVEL_BINDING"
      ],
      captured_eval,
      <%= @esocode %>
    ]
  }["eval"]
}[&:"send"]
```

We should also make our identity function available, and just to reduce the usage of unusual characters, we'll concentrate all the `<<`s for bitshifts to a single instance at the end:

```erb
->&captured_shovel{
  ->captured_identity{
    ->&captured_send{
      ->captured_eval{
        captured_send[
          captured_send[
            "",
            captured_eval,
            "TOPLEVEL_BINDING"
          ],
          captured_eval,
          <%= @esocode %>
        ]
      }["eval"]
    }[&:"send"]
  }[->_{_}]
}[&:<<]
```

Now, keep in mind that Ruby lets you use underscores in variable and function names. So we can replace all the lambda arguments with different numbers of underscores:

```erb
->&_{
  ->__{
    ->&___{
      ->____{
        ___[
          ___[
            "",
            ____,
            "TOPLEVEL_BINDING"
          ],
          ____,
          <%= @esocode %>
        ]
      }["eval"]
    }[&:"send"]
  }[->_{_}]
}[&:<<]
```

Now all that's left is to replace the strings! We can create the string `"send"` like this:

```ruby
""<<__[__[[[]]<=>[]]--_[[[]]<=>[],[[]]<=>[]]--_[_[_[_[[[]]<=>[],[[]]<=>[]],[[]]<=>[]],[[]]<=>[]],[[]]<=>[]]--_[_[_[_[_[[[]]<=>[],[[]]<=>[]],[[]]<=>[]],[[]]<=>[]],[[]]<=>[]],[[]]<=>[]]--_[_[_[_[_[_[[[]]<=>[],[[]]<=>[]],[[]]<=>[]],[[]]<=>[]],[[]]<=>[]],[[]]<=>[]],[[]]<=>[]]]<<__[__[[[]]<=>[]]--_[_[[[]]<=>[],[[]]<=>[]],[[]]<=>[]]--_[_[_[_[_[[[]]<=>[],[[]]<=>[]],[[]]<=>[]],[[]]<=>[]],[[]]<=>[]],[[]]<=>[]]--_[_[_[_[_[_[[[]]<=>[],[[]]<=>[]],[[]]<=>[]],[[]]<=>[]],[[]]<=>[]],[[]]<=>[]],[[]]<=>[]]]<<__[_[[[]]<=>[],[[]]<=>[]]--_[_[[[]]<=>[],[[]]<=>[]],[[]]<=>[]]--_[_[_[[[]]<=>[],[[]]<=>[]],[[]]<=>[]],[[]]<=>[]]--_[_[_[_[_[[[]]<=>[],[[]]<=>[]],[[]]<=>[]],[[]]<=>[]],[[]]<=>[]],[[]]<=>[]]--_[_[_[_[_[_[[[]]<=>[],[[]]<=>[]],[[]]<=>[]],[[]]<=>[]],[[]]<=>[]],[[]]<=>[]],[[]]<=>[]]]<<__[_[_[[[]]<=>[],[[]]<=>[]],[[]]<=>[]]--_[_[_[_[_[[[]]<=>[],[[]]<=>[]],[[]]<=>[]],[[]]<=>[]],[[]]<=>[]],[[]]<=>[]]--_[_[_[_[_[_[[[]]<=>[],[[]]<=>[]],[[]]<=>[]],[[]]<=>[]],[[]]<=>[]],[[]]<=>[]],[[]]<=>[]]]}
```

(Note that, to save on allowed characters, we have eliminated the `+`, replacing it with the equivalent `--` since we already need `-` for the `->` in the lambda syntax.)

Following the same methodology, we get [the template in this repo](https://github.com/amcaplan/functional_brainruby/blob/main/views/template.erb), and we perform the same transformation to userland code in the [generator](https://github.com/amcaplan/functional_brainruby/blob/main/lib/functional_brainruby/generator.rb).

And that's it!
