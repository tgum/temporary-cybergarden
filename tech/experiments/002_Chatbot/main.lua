tokenize = require "tokenize"

print("JIM: Hello!")

function slice(tbl, start, last)
  if last == nil then last = #tbl end
  if start == nil then start = 1 end
  y ={}
  for i = start,last do table.insert(y,tbl[i]) end
  return y
end

function matches(pattern, input)
  --if #input < #pattern then return 0 end
  local i = 1
  inputidx = 1
  while i <= #pattern do
    word = pattern[i]
    inpword = input[inputidx]
    if word == "*" then
      if inpword == pattern[i+1] then
        i = i+1
        inputidx = inputidx-1
      elseif inpword == nil then
        if i == #pattern then
          return inputidx
        else
          return 0
        end
      end
    else
      if inpword ~= word then
        return 0
      end
      i = i + 1
    end
    inputidx = inputidx+1
  end
  return inputidx-1
end

function applyrule(rule, input)
  output = {}
  stage = 0
  local i = 1
  applied = false
  while i <= #input do
    --pt(slice(input, i))
    m = matches(rule.pattern, slice(input,i))
    if m > 0 then
      i = i + m
      applied = true
      for i,w in ipairs(rule.substitution) do table.insert(output, w) end
    else
      table.insert(output, input[i])
      i = i + 1
    end
  end
  return output, applied
end

function lt(t)for k,_ in pairs(t)do print(k)end end
function pt(t)for i,k in ipairs(t)do io.write(k,", ")end print() end
--lt(table)

rules = require "rules"

while true do
  io.write("YOU: ")
  val = io.read("*l")
  val = val:gsub("[^%w%s]", ""):lower()

  out = tokenize(val)
  terminated = false
  for j = 0, 100 do
    ruleapplied = false
    for i,rule in ipairs(rules) do
      out,applied=applyrule(rule, out)
      if applied then
        ruleapplied = true
        terminated = rule.terminator
        if terminated then break end
      end
    end
    if not ruleapplied or terminated then break end
  end
  print("JIM: ",table.concat(out, " "))
  --print(terminated)
end