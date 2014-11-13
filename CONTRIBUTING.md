# Contributing

## Developing

If you'd like to submit a patch:

1. Fork the project.
2. Make your feature addition or bug fix.
3. Add [tests](#testing) for it. This is important so that it isn't broken in a
   future version unintentionally.
4. Commit. **Do not touch any unrelated code, such as the gemspec or version.**
   If you must change unrelated code, do it in a commit by itself, so that it
   can be ignored.
5. Send a pull request.

## Testing

### Install prerequisites

Install the latest version of [Bundler](http://gembundler.com)

    $ gem install bundler

Clone the project

    $ git clone https://github.com/berkshelf/vagrant-berkshelf.git

and run:

    $ cd vagrant-berkshelf
    $ bundle install

Bundler will install all gems and their dependencies required for testing and developing.

### Running tests

One-time run with Rake

    $ bundle exec rake spec

Or you can setup a quick feedback loop with Guard

    $ bundle exec guard start
    guard> rspec
