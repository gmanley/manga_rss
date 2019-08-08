module MangaRSS
  module Entities
    class Title < Entity
      attribute :name, Types::Strict::String
      attribute :url, Types::Strict::String
      attribute :author, Types::Strict::String.optional.meta(omittable: true)
    end
  end
end
