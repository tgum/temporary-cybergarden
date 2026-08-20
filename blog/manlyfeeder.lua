--[[
  THE MANLY FEEDER v0.1 by tgum
tiny script i made to generate atom feeds from some files. its really scuffed but you can reuse it if u layout ur stuff exacly like me lol

to use do smth like `lua manlyfeeder.lua > feed.atom` because unix philosophy or something
]]

info = {
  title = "tgum's CyberLog",
  subtitle = "my lil blog :3",
  author = "tgum",
  author_uri = "https://tgum.net",
  url = "https://cybergarden.tgum.net/blog/",

  generator = "ManlyFeeder v0.1",
}

function listdir()
  -- i dont if theres a builtin way to list files in lua so um yea
  filez = {}
  reader = io.popen("ls | sort -r") -- sort -r reverses the input
  while true do
    file = reader:read()
    if file == nil then break end
    table.insert(filez, file)
  end
  reader:close()
  return filez
end

function ispost(fname)
  -- only checks if it starts with a digit and ends with ".md"
  return (fname:sub(#fname-2, #fname)==".md") and (tonumber(fname:sub(1,1))~=nil)
end

function format_date(date)
  -- 2026-08-06T18:12:00Z iso 8601 i think
 return ("%04d-%02d-%02dT20:00:00Z"):format(date.year,date.month,date.day)
end

function get_title(file)
  -- replaces underscores with spaces and removes the ".md"
  title = file:sub(1, #file-3)
  return title:gsub("_", " ")
end

function get_url(file)
  -- returns the url that goes to the post
  file = file:sub(1, #file-2).."html"
  return info.url..file
end

months = {"January", "Febuary", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"}
function get_date(file)
  -- scuffed as hell, parses the first line of the post to extract publication date
  --  format: "*written: 4th August 2026*"
  f = io.open(file)
  written = f:read()
  f:close()
  written = written:sub(#"*written: "+1, #written-1)
  date = {}
  date.year = tonumber(written:sub(#written-3, #written))

  monthstart = #"0th "

  day = tonumber(written:sub(1,1))
  if tonumber(written:sub(1,2)) ~= nil then
    day = tonumber(written:sub(1,2))
    monthstart = monthstart + 1
  end
  date.day = day

  monthname = written:sub(monthstart+1, #written-5)
  for i, month in ipairs(months) do
    if monthname == month then
      date.month = i
      break
    end
  end

  for i,value in ipairs({"year","month","day"}) do
    if date[value] == nil then
      error("not valid "..value.." for file "..file)
    end
  end

  return date
end

function format_header()
  local date = format_date(os.date("*t"))
  return ([[<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">

<title>%s</title>
<subtitle>%s</subtitle>
<link href="%s"/>
<updated>%s</updated>
<author>
  <name>%s</name>
  <uri>%s</uri>
</author>
<generator>%s</generator>
<id>%s</id>
]]):format(info.title, info.subtitle, info.url, date, info.author, info.author_uri, info.generator, info.url)
end

function format_entry(post)
  return ([[

<entry>
  <title>%s</title>
  <content src="%s"></content>
  <link rel="alternate" href="%s"/>
  <id>%s</id>
  <updated>%s</updated>
  <summary>%s</summary>
</entry>
]]):format(post.title, post.url, post.url, post.url, format_date(post.date), "umm idek gus")
end

posts = {}
for i,file in ipairs(listdir()) do
  if ispost(file) then
    post = {
      title = get_title(file),
      url = get_url(file),
      date = get_date(file),
    }
    table.insert(posts, post)
  end
end

output = ""
output=output..format_header()
for i,post in ipairs(posts) do
  output=output..format_entry(post)
end
output=output.."</feed>"

print(output)

