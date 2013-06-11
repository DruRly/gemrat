# Gemrat

Add the latest version of gems to your Gemfile from the command line.

* No need to search RubyGems for version numbers
* No need to edit your Gemfile directly
* Gemrat bundles automatically


## Installation

Add this line to your application's Gemfile:

    gem 'gemrat'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gemrat

## Usage
Add the latest version of a gem to your Gemfile and bundle. Formated: (gem 'name', 'version')
<pre>
$ gemrat gem_name
</pre>

Add the latest version of sinatra to your Gemfile and bundle
<pre>
$ gemrat sinatra

#=> gem 'sinatra', '1.4.3' added.
#=> Bundling...
</pre>

Add the latest version of rspec to your Gemfile and bundle
<pre>
$ gemrat rspec

#=> gem 'rspec', '2.13.0' added.
#=> Bundling...
</pre>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
