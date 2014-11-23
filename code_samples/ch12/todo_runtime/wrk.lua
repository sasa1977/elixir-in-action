counter = 0

request = function()
  which = "list_"..math.random(1000)
  day = math.random(31)
  if day < 10 then day = "0" .. day end
  if math.random(5) < 5 then
    wrk.method = "GET"
    path = "/entries?list="..which.."&date=201312"..day
  else
    wrk.method = "POST"
    path = "/add_entry?list="..which.."&date=201312"..day.."&title=Dentist"
  end
  return wrk.format(nil, path)
end