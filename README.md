# Beyond The API Test Helpers

Beyond The API is a framework created to standardize Rails APIs and make things easier.

This gem consist in various test helpers for testing an application based in Beyond The API gem.

The tests are based in minitest.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'beyond_the_api_test_helpers', require: false, group: :test
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install beyond_the_api_test_helpers

## Installation

Include in your test_helper.rb:
```ruby
require 'beyond_the_api_test_helpers'
```

## Usage

#### Base helpers

TODO: helpers descriptions

* json
* logged_in_headers
* not_logged_in_headers
* response_assertions
* assert_meta_now
* assert_meta_version

### Controller tests

TODO: helpers descriptions

#### Common assertions

* assert_request_needs_to_be_logged
* assert_not_found_request
* assert_parameter_missing_request

#### Index assertions

* assert_request_index_valid
* assert_request_index_total_count
* assert_request_index_paginated
* assert_request_index_with_filters
* assert_request_index_not_found

#### Show assertions

* assert_request_show_valid
* assert_request_show_not_found

#### Create assertions

* assert_request_create_valid
* assert_request_create_missing_param
* assert_request_create_with_errors
* assert_request_create_not_found

#### Update assertions

* assert_request_update_valid
* assert_request_update_missing_param
* assert_request_update_with_errors
* assert_request_update_not_found

#### Destroy assertions

* assert_request_destroy_valid
* assert_request_destroy_not_found

#### Restore assertions

* assert_request_restore_valid
* assert_request_restore_not_found

### Model tests

TODO: helpers descriptions

* should have_foreign_key
* should have_model_translations
* should have_valid_association
* should have_valid_enum
* should require_association
* should validate_timeliness

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/williamweckl/beyond_the_api_test_helpers.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
