require 'chronic'

module MangaRSS
  module Providers
    class Bato
      BASE_URL = 'https://bato.to'
      URL_FORMAT = "#{BASE_URL}/series/%<external_id>s"
      CHROME_USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3532.6 Safari/537.36'

      Response = Struct.new(:success, :title, :chapters)

      def initialize(external_id)
        @url = URL_FORMAT % { external_id: external_id }
      end

      def call
        # Scrape site into titles
        response = http.get(@url)
        doc = Nokogiri::XML(response.body)

        title = extract_title(doc)
        chapters = extract_chapters(doc)
        Response.new(true, title, chapters)
      end

      private

      def extract_title(doc)
        attributes = {}
        attributes[:name] = doc.at_css('.item-title a').text
        attributes[:url] = @url

        author_el = doc.css('.attr-item').find { |e| e.text.include?('Authors:') }
        cleaned_text = author_el.text.gsub(/\s+/, ' ').strip
        if author_el && match = cleaned_text.match(/(Authors: )(.*)/)
          attributes[:author] = match[2]
        end

        Entities::Title.new(attributes)
      end

      def extract_chapters(doc)
        doc.css('.chapter-list .item').map do |item|
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
              attributes[:published_at] = Chronic.parse(el.text, context: :past)
            end
          end

          attributes[:url] = relative_url_to_absolute(chapter_a[:href])

          Entities::Chapter.new(attributes)
        end
      end

      def relative_url_to_absolute(url)
        URI.join(BASE_URL, url).to_s
      end

      def http
        @http ||= HTTP.headers("User-Agent": CHROME_USER_AGENT)
      end
    end
  end
end
