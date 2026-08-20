tokenize = require "tokenize"

rules = {}

f = io.open("rules.txt")
line = f:read()
while line ~= nil do
  if #line > 0 and line:sub(1,1) ~= "#" then
    pattern = {}
    substitution = {}
    terminator = false
    foundseparator = false
    for i,token in ipairs(tokenize(line)) do
      if token:sub(2,2) == ">" then
        foundseparator = true
        terminator = token == "=>"
      else
        if not foundseparator then
          table.insert(pattern, token)
        else
          table.insert(substitution, token)
        end
      end
    end
    table.insert(rules, {pattern = pattern, substitution = substitution, terminator = terminator})
  end

  line = f:read()
end

return rules