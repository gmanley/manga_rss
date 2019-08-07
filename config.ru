require_relative 'lib/manga_rss/boot'

MangaRSS.setup
run MangaRSS::App.freeze.app
