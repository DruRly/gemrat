# Gemrat

Add the latest version of a gem to your Gemfile from the command line.

* No need to search RubyGems for version numbers
* No need to edit your Gemfile directly
* Gemrat bundles automatically

## Usage
Add the latest version of a gem to your Gemfile and bundle. Formated: (gem 'name', 'version')
<pre>
$ gemrat gem_name
</pre>

Add the latest version of sinatra to your Gemfile and bundle
<pre>
$ gemrat sinatra

#=> gem 'sinatra', '1.4.3' added to your Gemfile.
#=> Bundling...
</pre>

Add the latest version of rspec to your Gemfile and bundle
<pre>
$ gemrat rspec

#=> gem 'rspec', '2.13.0' added to your Gemfile.
#=> Bundling...
</pre>

<br/>
<br/>

![gemrat](http://i.qkme.me/3ut4r1.jpg)

## Installation

Add this line to your application's Gemfile:

    gem 'gemrat'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gemrat
