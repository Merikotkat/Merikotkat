# todo apparently this is broken in rails or ruby or whatever 4.0.something
module I18n
  class MissingTranslation
    def html_message
      "translation missing: #{keys.join('.')}"
    end
  end
end