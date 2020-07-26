# Functional Brainruby

Welcome to Functional Brainruby, the esoteric programming language which is basically just Ruby.

Using Functional Brainruby, you can write any Ruby program using just 14 non-alphanumeric characters:

```
-<>&_{}[]\",=:#
```

See the [`examples`](https://github.com/amcaplan/functional_brainruby/tree/main/examples) directory for Hello World and Fizzbuzz programs written in Functional Brainruby.

You shouldn't try to write Functional Brainruby yourself.  The compiler will do the hard work for you, turning your Ruby code into Functional Brainruby code.  To compile, run the generator with 2 arguments:

1. The name of the file to compile
2. The name of the output file

For example:

``` sh
functional_brainruby /path/to/some/file.rb /path/to/output/file.rb
```

You can then run the output file as usual:

``` sh
ruby /path/to/output/file.rb
```

Explanation coming soon...

That's it!  Have fun!

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/functional_brainruby`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Do not under any circumstances add this line to a Gemfile!

Install it yourself as:

    $ gem install functional_brainruby

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/amcaplan/functional_brainruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/amcaplan/functional_brainruby/blob/main/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FunctionalBrainruby project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/amcaplan/functional_brainruby/blob/master/CODE_OF_CONDUCT.md).
