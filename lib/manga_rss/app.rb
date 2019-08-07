require 'json'

module MangaRSS
  class App < Roda
    plugin :halt
    plugin :symbol_status
    plugin :indifferent_params
    plugin :error_handler
    plugin :common_logger, MangaRSS.logger

    route do |r|
      r.on 'rss', String do |provider|
        @provider = Providers[provider]

        r.is String do |external_id|
          @provider.new(external_id).call
        end
      end
    end
  end
end
