require 'logger'
require 'open-uri'

ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'])

module MangaRSS
  @initializers = []

  def self.root
    File.expand_path('../..', __dir__)
  end

  def self.version
    Dir.chdir(root) do
      `git rev-parse --short HEAD`.chomp
    end
  end

  def self.env
    ENV['RACK_ENV']
  end

  def self.logger
    return @logger if @logger

    @logger = Logger.new($stdout)
    @logger.level = Logger::FATAL if env == 'test'
    @logger
  end

  def self.setup(except: [])
    @initializers.each do |initializer|
      if except.include?(initializer[:name])
        logger.info("Skipping initializer #{initializer[:name]}")
      else
        logger.info("Loading initializer #{initializer[:name]}")
        initializer[:block].call
      end
    end
  end

  def self.initializer(name, &block)
    @initializers << { name: name, block: block }
  end

  initializer :dotenv do
    existing_env_files = [
      ".env.#{env}.local",
      ('.env.local' unless env == 'test'),
      ".env.#{env}",
      '.env'
    ].compact.map { |p| File.join(root, p) if File.exist?(p) }.compact

    Dotenv.load!(*existing_env_files) if existing_env_files.any?
  end

  initializer :load_files do
    path = File.join(root, 'lib')
    $LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)

    require 'manga_rss/app'

    require 'manga_rss/entities/entity'
    require 'manga_rss/entities/title'
    require 'manga_rss/entities/chapter'

    require 'manga_rss/rss_emitter'

    require 'manga_rss/providers/bato'
    require 'manga_rss/providers'
  end
end
