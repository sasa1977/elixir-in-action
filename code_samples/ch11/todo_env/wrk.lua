-- Instructions:
--
-- 1. Make sure to delete the `persist` folder before starting the test
-- 2. Start the system in prod environment: MIX_ENV=prod iex -S mix
-- 3. In a separate shell, invoke wrk
--    The command I've used: wrk -t4 -c20 -d30s --latency -s wrk.lua http://localhost:5454

counter = 0

request = function()
  which = "list_"..math.random(1000)
  day = math.random(31)
  if day < 10 then day = "0" .. day end
  if math.random(5) < 5 then
    wrk.method = "GET"
    path = "/entries?list="..which.."&date=2018-12-"..day
  else
    wrk.method = "POST"
    path = "/add_entry?list="..which.."&date=2018-12-"..day.."&title=Dentist"
  end
  return wrk.format(nil, path)
end
