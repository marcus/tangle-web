class AddPgTrgrmTrigramSearchExtensiona < ActiveRecord::Migration
  def up
    if is_superuser?
      execute 'CREATE EXTENSION IF NOT EXISTS pg_trgm'
    else
      puts "CREATE EXTENSION requires superuser. You'll need to manually add it to this database " <<
           "as a superuser. Also, to make it added by default to any new databases, run " <<
           "`psql template1 -c 'CREATE EXTENSION pg_trgm;'`"
    end
  end

  def down
    if is_superuser?
      execute 'DROP EXTENSION IF EXISTS pg_trgm'
    else
      puts "DROP EXTENSION pg_trgm requires superuser"
    end
  end

  def is_superuser?
    ActiveRecord::Base.connection.execute('show is_superuser').first['is_superuser'] == 'on'
  end
end
