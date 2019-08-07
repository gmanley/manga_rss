module MangaRSS
  module Providers
    AVAILABLE = {
      'bato' => Bato
    }

    def self.[](name)
      AVAILABLE[name]
    end
  end
end
