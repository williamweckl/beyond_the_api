module BeyondTheApiTestHelpers
  module I18nTestHelpers
    def assert_i18n_for_all_locales
      I18n.available_locales.each do |locale|
        ActiveRecord::Base.transaction do
          Faker::Config.locale = I18n.locale = locale
          yield
          raise ActiveRecord::Rollback
        end
      end
    end
  end
end
