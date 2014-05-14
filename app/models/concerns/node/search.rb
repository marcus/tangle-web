module Node::Search
  extend ActiveSupport::Concern

  included do

    SIMILARITY_LIMIT = 0.2

    self.table_name = :search_results_view

    scope :similar_to, ->(query) {
      similarity_select = ActiveRecord::Base.sanitize_sql_array(["similarity(title, ?) AS similarity", query])
      select(['*', similarity_select]).order('similarity DESC', 'priority ASC').
      where("similarity(title, ?) >= ?", query, SIMILARITY_LIMIT)
    }

  end

  module InstanceMethods
    def similarity
      read_attribute(:similarity)
    end
  end

end
