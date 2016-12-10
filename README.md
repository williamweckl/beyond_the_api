# Beyond The API Test Helpers

Beyond The API is a framework created to standardize Rails APIs and make things easier.

This gem consist in various render helpers to help render JSON on common use cases like pagination and sort.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'beyond_the_api', '~> 0.0.1'
```

And then execute:

    $ bundle install

## Installation

Include in your application_controller.rb or whatever controller you want to use the helpers:
```ruby
include BeyondTheApi::RenderHelpers
```

## Usage

#### Base

* json patterns
* meta
* model serializer helper
* current_user
* versioning

#### Index renders

* total_count
* total_pages
* pagination
* filters
* sort

#### Show renders

TODO

#### Common renders

TODO

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/williamweckl/beyond_the_api.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
