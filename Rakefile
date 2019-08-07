require_relative 'lib/manga_rss/boot'

def migrate(version = nil)
  Sequel.extension :migration
  Sequel::Migrator.apply(MangaRSS.database, 'db/migrate', version)
end

# Loading a model without the table or database existing
# raises an exception.
MangaRSS.setup(except: [:load_files])

namespace :db do
  task :drop do
    db = Sequel.connect(ENV['DATABASE_URL'])
    system("dropdb #{db.opts[:database]}")
  end

  task :create do
    db = Sequel.connect(ENV['DATABASE_URL'])
    system("createdb #{db.opts[:database]}")
  end

  task :migrate, [:version] do |_, args|
    ENV['SCRUTINATOR_MIGRATING'] = 'true'
    version = args[:version] ? Integer(args[:version]) : nil
    migrate(version)
    puts 'Migration complete'
  end

  desc 'Rollback the database N steps ' \
       '(you can specify the version with `db:rollback[N]`)'
  task :rollback, [:step] do |_task, args|
    step = args[:step] ? Integer(args[:step]) : 1
    version = 0

    target_migration =
      MangaRSS.database[:schema_migrations]
        .reverse_order(:filename)
        .offset(step)
        .first
    if target_migration
      version = Integer(target_migration[:filename].match(/([\d]+)/)[0])
    end

    migrate(version)
    puts 'Rollback complete'
    puts "Rolled back to version: #{version}"
  end

  desc 'Generate a new migration file `db:generate[create_books]`'
  task :generate, [:name] do |_, args|
    name = args[:name]
    abort('Missing migration file name') if name.nil?

    content = <<~STR
      Sequel.migration do
        change do
        end
      end
    STR

    timestamp = Time.now.to_i
    path = File.expand_path("db/migrate/#{timestamp}_#{name}.rb", __dir__)
    File.write(path, content)
    puts "Generated: #{path}"
  end
end
