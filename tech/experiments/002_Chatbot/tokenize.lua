function tokenize(str)
  output = {}
  token = ""
  for i = 1,#str do
    char = str:sub(i,i)
    if char == " " then
      if #token > 0 then
        table.insert(output, token)
        token = ""
      end
    else
      token = token..char
    end
  end
  if #token > 0 then
    table.insert(output, token)
  end
  return output
end

return tokenize