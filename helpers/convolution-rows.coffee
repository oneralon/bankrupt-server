module.exports = (rows, field) ->
  items = {}
  r = RegExp("^#{field}\\.\\w+")
  e = RegExp("^#{field}\\.")
  for row in rows
    item = items[row.id] or {}
    if item.id
      subitem = {}
      for key, val of row
        if r.test key then subitem[key.replace e, ''] = val
      item[field].push subitem
    else
      subitem = {}
      item[field] = []
      for key, val of row
        if r.test key then subitem[key.replace e, ''] = val
        else item[key] = val
      item[field].push subitem
      items[item.id] = item
  result = []
  for _, val of items
    result.push val
  result