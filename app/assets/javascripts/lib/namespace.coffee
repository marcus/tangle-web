# Nodes ||= {} # In application.js since CoffeeScript makes it impossible to create a global

Nodes.namespace = (ns_string) ->
  parts = ns_string.split('.')
  parent = Nodes

  # strip redundant leading global
  parts = parts.slice(1) if (parts[0] == "Nodes")

  for part in parts
    # create a property if it doesn't exist
    parent[part] = {} if (typeof parent[part] == "undefined")
    parent = parent[part]

  parent

