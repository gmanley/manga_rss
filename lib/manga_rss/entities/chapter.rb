module MangaRSS
  module Entities
    class Chapter < Entity
      attribute :text, Types::Strict::String
      attribute :group_name, Types::Strict::String
      attribute :group_url, Types::Strict::String
      attribute :uploader_name, Types::Strict::String
      attribute :uploader_url, Types::Strict::String
      attribute :published_at, Types::Time
      attribute :url, Types::Strict::String
    end
  end
end
