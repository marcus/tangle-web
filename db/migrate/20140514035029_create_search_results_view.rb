class CreateSearchResultsView < ActiveRecord::Migration
  def up
    # NOTE: priority controls order when text has the exact same similarity.
    execute("CREATE VIEW search_results_view AS
      SELECT nodes.title AS title,
          'Node' AS result_type, nodes.uuid AS uuid, 1 as priority
        FROM nodes
    ")
  end

  def down
    execute("DROP VIEW search_results_view")
  end
end
