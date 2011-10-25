module Tangled
  module Uuid
    def init_uuid
      self.uuid = SecureRandom.uuid
    end

  end
end
