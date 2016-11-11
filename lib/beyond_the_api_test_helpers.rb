require 'beyond_the_api_test_helpers/i18n_test_helpers'
Dir["#{File.dirname(__FILE__)}/beyond_the_api_test_helpers/request/**/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/beyond_the_api_test_helpers/shoulda/**/*.rb"].each { |f| require f }

I18n.enforce_available_locales = false

class TestExceptionLocalizationHandler
  # :reek:LongParameterList: { enabled: false }
  def call(exception, _locale, _key, _options)
    raise exception.message
  end
end

class TestLanguage
  cattr_accessor :current
end

ActiveSupport::TestCase.class_eval do
  include BeyondTheApiTestHelpers::I18nTestHelpers

  # Setup ActiveJob to run with test adapter
  ActiveJob::Base.queue_adapter = :test

  # Raise errors on i18n missing translations
  I18n.exception_handler = ::TestExceptionLocalizationHandler.new

  Faker::Config.locale = I18n.locale = TestLanguage.current = I18n.available_locales.sample

  teardown do
    I18n.locale = TestLanguage.current
  end
end

ActionDispatch::IntegrationTest.class_eval do
  include BeyondTheApiTestHelpers::Request::Helpers
  include BeyondTheApiTestHelpers::Request::CommonAssertions
  include BeyondTheApiTestHelpers::Request::IndexAssertions
  include BeyondTheApiTestHelpers::Request::ShowAssertions
  include BeyondTheApiTestHelpers::Request::CreateAssertions
  include BeyondTheApiTestHelpers::Request::UpdateAssertions
  include BeyondTheApiTestHelpers::Request::DestroyAssertions
  include BeyondTheApiTestHelpers::Request::RestoreAssertions
end
