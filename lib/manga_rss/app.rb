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
          result = @provider.new(external_id).call

          if result.success
            response['Content-Type'] = 'application/atom+xml'
            RSSEmitter.new(result.title, result.chapters).perform.to_s
          else
            halt 500
          end
        end
      end
    end
  end
end
