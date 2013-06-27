# Gemrat

Add the latest version of a gem to your Gemfile from the command line.

* No need to search RubyGems for version numbers
* No need to edit your Gemfile directly
* Gemrat bundles automatically

<br/>

## Usage
Add the latest version of a gem to your Gemfile and bundle. Formated: (gem 'name', 'version')
<pre>
$ gemrat gem_name
</pre>

<br/>

Add the latest version of sinatra to your Gemfile and bundle
<pre>
$ gemrat sinatra

#=> gem 'sinatra', '1.4.3' added to your Gemfile.
#=> Bundling...
</pre>

<br/>
Add multiple gems
<pre>
$ gemrat rspec capybara sidekiq

#=> gem 'rspec', '2.13.0' added to your Gemfile.
#=> gem 'capybara', '2.1.0' added to your Gemfile.
#=> gem 'sidekiq', '2.12.4' added to your Gemfile.
#=> Bundling...
</pre>

<br/>


Get help

<pre>
$ gemrat --help OR gemrat -h

Gemrat

Add gems to Gemfile from the command line.

Usage: gemrat [GEM_NAME] [OPTIONS]

Options:

  -g [--gemfile]  # Specify the Gemfile to be used. Defaults to 'Gemfile'.
  -h [--help]     # Print these usage instructions.
</pre>
<br/>

![gemrat](http://i.qkme.me/3ut4r1.jpg)

<br/>
## Installation

Add this line to your application's Gemfile:

    gem 'gemrat'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gemrat

<br/>

## Development

Run the entire test suite with:

<pre>
$ rake
</pre>

We encourage you to run

<pre>
$ guard
</pre>

in development, because it's awesome!
