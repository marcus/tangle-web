module Tangled
  # This is an (incomplete) example client, what things would look like on a phone or tablet
  # Client asks, then puts and resolves conflicts (does all the work)
  # server is just sends data, writes data and validates
  class SyncClient

    def init(endpoint)
      @last_sync = Sync.last.where(:endpoint => @endpoint)
      @this_sync = Sync.new(:endpoint => @endpoint).save
      @local_changes = gather_local
      @remote_changes = gather_remote
    end

    def gather_local
      # TODO - count, batch
      changes = {}
      Tangle::Application.config.syncable_models.each{|m|
        model = m.to_s.tableize
        changes[model] = {}
        if @last_sync
          changes[model][:created] = m.where("created_at < ?", @last_sync.sync_finished)
          changes[model][:modified] = m.where("updated_at < ?", @last_sync.sync_finished)
        else
          changes[model][:created] = m.all
          changes[model][:modified] = []
        end
        changes
      }
    end

    def gather_remote
      # @endpoint = 'http://localhost:3000'
      changes = {}
      Tangle::Application.config.syncable_models.each{ |m|
        model = m.to_s.tableize
        changes[model] = {}
        resource = RestClient::Resource.new "http://localhost:3000/#{model}.json"
        if @last_sync
          changes[model][:created] = resource.get
          changes[model][:modified] = resource.get :params => {:modified_after => @last_sync.sync_finished}
        else
          changes[model][:created] = resource.get
          changes[model][:modified] = []
        end
      }
      changes
    end

  end

end
