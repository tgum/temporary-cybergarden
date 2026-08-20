function push(item)
  table.insert(stack, item)
end
function pop()
  if #stack == 0 then return 0 end
  i = stack[#stack]
  stack[#stack] = nil
  return i
end
function getmem(addr)
  v = mem[addr+1]
  if v == nil then v = 0 end
  return v
end
function setmem(addr, val)
  if addr == -100 then io.write(val)
  elseif addr == -101 then io.write(string.char(val))
  elseif addr == -102 then debug = val ~= 0
  end
  mem[addr+1] = val
end

function printarray(arr, name)
  for i, element in ipairs(arr) do
    if element ~= 0 or #arr < 100 then
      print(name.."["..(i-1).."] = "..element)
    end
  end
end
function printstack()
  printarray(stack, "stack")
end

mem = {}
ramsize = 10000
for i = 1,ramsize do mem[i] = 0 end
print("ram initialized!")
stack = {}
rstack = {}

program ={
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,60,17,1,1000,3,7,3,1,5,7,9,1,5,8,1,-100,8,1,44,1,-101,8,1,1,9,3,1,0,7,10,14,13,1,4,18,1,-33,17,1,10,1,-101,8,1,999,10,1,-100,8,1,10,1,-101,8,1,5,7,1,-100,8,21,1,1000,3,1,0,8,1,1,8,1,0,3,1,2,8,1,3,8,1,356,19,3,1,143,19,1,388,16,3,1,145,19,1,199,16,3,1,150,19,1,228,16,3,1,155,19,3,1,160,19,9,1,248,16,3,1,173,19,1,317,16,2,1,-46,17,13,20,1,64,10,13,20,1,59,10,13,20,1,45,10,13,20,3,1,48,10,14,13,4,1,58,10,14,11,20,3,1,65,10,14,13,4,1,91,10,14,11,20,3,1,97,10,14,13,4,1,123,10,14,11,20,1,356,19,3,1,186,19,13,1,7,18,1,-101,8,1,-16,17,1,0,7,1,-100,8,1,369,19,1,99,15,2,1,356,19,3,1,143,19,5,1,10,10,13,9,1,99,16,1,-18,17,3,1,155,19,3,13,1,6,18,4,1,3,9,4,13,1,2,11,1,1,10,1,3,8,1,48,10,1,2,7,1,10,11,9,1,2,8,1,356,19,3,1,160,19,1,-22,18,1,2,7,1,3,7,11,1,375,19,1,0,3,1,2,8,1,3,8,1,99,15,1,65,10,1,330,9,7,1,375,19,1,96,15,9,14,16,3,17,19,6,21,-1,15,5,7,11,13,0,1,18,20,8,-1,10,2,4,-1,-1,-1,1,1,7,3,7,4,1,1,9,1,1,8,20,1,10,1,-101,8,20,1,0,7,4,5,8,1,1,9,1,0,8,20,2,1,1000,15,

--0,0,0,0,1,100,15,1,1000,3,7,1,-100,8,1,44,1,-101,8,1,1,9,3,1,0,7,10,14,13,1,4,18,1,-25,17,1,10,1,-101,8,1,999,10,1,-100,8,21,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1000,3,1,0,8,1,1,8,1,0,3,1,2,8,1,3,8,1,1,7,3,7,3,13,1,262,16,4,1,1,9,1,1,8,3,1,45,10,1,151,16,1,-1,1,3,8,2,1,118,15,3,1,48,10,3,14,1,194,16,3,1,10,10,14,13,1,194,16,1,3,7,1,6,18,1,1,1,3,8,1,2,7,1,10,11,9,1,2,8,2,1,118,15,2,1,3,7,13,1,221,16,1,3,7,1,2,7,11,1,248,19,1,0,3,1,2,8,1,3,8,1,65,10,3,14,1,244,16,3,1,26,10,14,13,1,244,16,1,267,19,1,118,15,2,1,118,15,1,0,7,8,1,0,7,1,1,9,1,0,8,20,2,2,1,1000,15,1,275,9,7,1,248,19,20,9,14,16,3,17,19,6,21,0,15,5,7,11,13,0,1,18,20,8,0,10,2,4,0,0,0,
}

for i, op in ipairs(program) do
  mem[i] = op
end

debug = true
intdebug = true

-- temporary solution until i implement file reading :)
strprg=[[]]
f = io.open("program.asm")
x = ""
while x ~= nil do
  strprg = strprg..x
  x = f:read(128)
end

for i = 1,#strprg do
  c = strprg:sub(i,i)
  setmem(i+1000-1, string.byte(c))
end

pc = 0
halted = false





opcodenames={"NOP","PSH","POP","DUP","SWP","OVR","ROT","LDS","STR","ADD","SUB","MUL","tfym","NOT","IBZ","JMP","CJP","RJP","RCJ","CLL","RET","HLT"}
opcodes = {
function() -- 00 NOP
  return
end,
function() -- 01 PSH
  push(getmem(pc))
  pc = pc + 1
end,
function() -- 02 POP
  pop()
end,
function() -- 03 DUP
  a = pop()
  push(a)
  push(a)
end,
function() -- 04 SWP
  a = pop()
  b = pop()
  push(a)
  push(b)
end,
function() -- 05 OVR
  a = pop()
  b = pop()
  push(b)
  push(a)
  push(b)
end,
function() -- 06 ROT
  c = pop()
  b = pop()
  a = pop()
  push(b)
  push(c)
  push(a)
end,
function() -- 07 LDS
  addr = pop()
  push(getmem(addr))
end,
function() -- 08 STR
  addr = pop()
  val = pop()
  setmem(addr, val)
end,
function() -- 09 ADD
  a = pop()
  b = pop()
  push(a+b)
end,
function() -- 10 SUB
  a = pop()
  b = pop()
  push(b-a)
end,
function() -- 11 MUL
  a = pop()
  b = pop()
  push(a*b)
end,
function() -- 12 free
  print("executing undefined unstruction. halting")
  halted = true
end,
function() -- 13 NOT
  a = pop()
  if a == 0 then
    push(1)
  else
    push(0)
  end
end,
function() -- 14 IBZ
  a = pop()
  if a < 0 then
    push(1)
  else
    push(0)
  end
end,
function() -- 15 JMP
  addr = pop()
  pc = addr
end,
function() -- 16 CJP
  addr = pop()
  cond = pop()
  if cond ~= 0 then
    pc = addr
  end
end,
function() -- 17 RJP
  raddr = pop()
  pc = pc + raddr - 1
end,
function() -- 18 RCJ
  raddr = pop()
  cond = pop()
  if cond ~= 0 then
    pc = pc + raddr - 1
  end
end,
function() -- 19 CLL
  table.insert(rstack, pc)
  addr = pop()
  pc = addr
end,
function() -- 20 RET
  addr = rstack[#rstack]
  rstack[#rstack] = nil
  pc = addr
end,
function() -- 21 HLT
  halted = true
  print("Program halted permanently")
end
}

while not halted do
  debug = pc >= 1000
  instruction = getmem(pc)
  if debug then
    print("pc:"..pc..",executing instruction:"..(opcodenames[instruction+1] or instruction))
  end
  pc = pc + 1
  if instruction >= 0 and instruction <= #opcodes then
    opcodes[instruction+1]()
  else
    halted = true
    print("CRASH! UNKNOWN INSTRUCTION '"..instruction.."'")
  end

  if debug then
    --printstack()
    x = ""
    if intdebug then x = io.read() end
    if x == "m" then
       nmem = {}
       for i = 1,4 do nmem[i] = getmem(i-1) end
       for i = 1,10 do nmem[i+4] = getmem(i+1000-1) end
       printarray(nmem, "mem vars")
     end
  end
end

print("bye!")
print("pc:"..pc)
--printstack()
--io.read()
--printarray(mem, "mem")