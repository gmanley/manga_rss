module MangaRSS
  module Providers
    class Bato
      BASE_URL =
      URL_FORMAT = 'https://bato.to/series/%<external_id>s'

      def initialize(external_id)
        @url = URL_FORMAT % external_id
      end

      def call
        binding.pry
      end
    end
  end
end
