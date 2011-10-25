module Tangled
  # This is an example client, what things would look like on a phone or tablet
  # Client asks, then puts and resolves conflicts (does all the work)
  # server is just sends data, writes data and validates
  class SyncClient

    def init(endpoint)
      @last_sync = Sync.last.where(:endpoint => "http://localhost:3001")
      gather_local
      # Gather local changes since last sync
      # Request remote changes since last sync
    end

    def gather_local
      Tangle::Application.config.syncable_models.each do |m|
        key = m.class.to_s.tableize
        @local_changes = {}
        @local_changes[key] = {}
        @local_changes[key][:created] = m.where("created_at < ", @last_sync.sync_finished, @last_sync.sync_finished)
        @local_changes[key][:modified] = m.where("updated_at < ", @last_sync.sync_finished, @last_sync.sync_finished)
      end

    end

  end

end
