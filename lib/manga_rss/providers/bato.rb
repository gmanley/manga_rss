module MangaRSS
  module Providers
    class Bato
      BASE_URL = 'https://bato.to'
      URL_FORMAT = "#{BASE_URL}/series/%<external_id>s"
      CHROME_USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3532.6 Safari/537.36'

      def initialize(external_id)
        @url = URL_FORMAT % { external_id: external_id }
      end

      def call
        # Scrape site into titles
        response = http.get(@url)
        doc = Nokogiri::XML(response.body)
        r = doc.css('.chapter-list .item').map do |item|
          attributes = {}

          chapter_a = item.at_css('a.chapt')
          attributes[:text] = chapter_a.text.gsub(/\s+/, ' ').strip

          item.at_css('.extra').children.each do |el|
            if el[:href]&.start_with?('/group')
              attributes[:group_name] = el.text
              attributes[:group_url] =relative_url_to_absolute(el[:href])
            elsif el[:href]&.start_with?('/user')
              attributes[:uploader_name] = el.text
              attributes[:uploader_url] = relative_url_to_absolute(el[:href])
            elsif el.name == 'i'
              attributes[:published_at] = el.text
            end
          end

          attributes[:url] = relative_url_to_absolute(chapter_a[:href])

          attributes
        end
      end

      private

      def relative_url_to_absolute(url)
        URI.join(BASE_URL, url).to_s
      end

      def http
        @http ||= HTTP.headers("User-Agent": CHROME_USER_AGENT)
      end
    end
  end
end
