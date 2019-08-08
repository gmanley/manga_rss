require 'rss'

module MangaRSS
  class RSSEmitter
    attr_reader :title, :chapters

    def initialize(title, chapters)
      @title = title
      @chapters = chapters
    end

    def perform
      RSS::Maker.make('atom') do |maker|
        maker.channel.author = title.author
        maker.channel.updated = Time.now.to_s
        maker.channel.about = title.url
        maker.channel.title = title.name

        chapters.each do |chapter|
          maker.items.new_item do |item|
            item.link = chapter.url
            item.title = chapter.text
            item.updated = chapter.published_at.to_s
          end
        end
      end
    end
  end
end
