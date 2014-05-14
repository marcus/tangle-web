# https://gist.github.com/937739
module Shared::UUID

  extend ActiveSupport::Concern

  included do
    self.primary_key = 'uuid'
    before_create :generate_uuid

    def generate_uuid
      self.id = UUIDTools::UUID.random_create.to_s
    end
  end
end
