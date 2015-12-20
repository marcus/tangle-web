class Export::BrainToJson
  def init
    puts "hi"
  end

  def export
    j = {}
    j[:nodes] = Node.all
    j[:links] = Link.all
    #j.to_json
    File.write('export.json', j.to_json)
  end
end
