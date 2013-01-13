# Tangle ||= {} # In application.js since CoffeeScript makes it impossible to create a global

Tangle.namespace = (ns_string) ->
  parts = ns_string.split('.')
  parent = Tangle

  # strip redundant leading global
  parts = parts.slice(1) if (parts[0] == "Tangle")

  for part in parts
    # create a property if it doesn't exist
    parent[part] = {} if (typeof parent[part] == "undefined")
    parent = parent[part]

  parent

