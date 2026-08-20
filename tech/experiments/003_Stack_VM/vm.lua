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
    v = mem[addr + 1]
    if v == nil then v = 0 end
    return v
end

function setmem(addr, val)
    if addr == -100 then
        io.write(val)
    elseif addr == -101 then
        io.write(string.char(val))
    elseif addr == -102 then
        debug = val ~= 0
    end
    mem[addr + 1] = val
end

function printarray(arr, name)
    for i, element in ipairs(arr) do
        if element ~= 0 or #arr < 100 then
            print(name .. "[" .. (i - 1) .. "] = " .. element)
        end
    end
end

function printstack()
    printarray(stack, "stack")
end

mem = {}
ramsize = 1500
for i = 1, ramsize do mem[i] = 0 end
print("ram initialized!")
stack = {}
rstack = {}

program = {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,60,17,1,1000,3,7,3,1,5,7,9,1,5,8,1,-100,8,1,44,1,-101,8,1,1,9,3,1,0,7,10,14,13,1,4,18,1,-33,17,1,10,1,-101,8,1,999,10,1,-100,8,1,10,1,-101,8,1,5,7,1,-100,8,21,-0,-0,-0,-0,1,1000,3,1,0,8,1,1,8,1,0,3,1,2,8,1,3,8,-0,-0,-0,-0,1,427,19,-0,-0,-0,-0,3,1,160,19,1,471,16,3,1,165,19,1,243,16,3,1,174,19,1,283,16,3,1,183,19,1,307,16,3,1,192,19,1,307,16,3,1,209,19,1,380,16,2,1,-52,17,-0,-0,-0,13,20,-0,-0,-0,-0,1,64,10,13,20,-0,-0,-0,-0,1,59,10,13,20,-0,-0,-0,-0,1,45,10,13,20,-0,-0,-0,-0,3,1,48,10,14,13,4,1,58,10,14,11,20,-0,-0,-0,-0,3,1,65,10,14,13,4,1,91,10,14,11,20,-0,-0,-0,-0,3,1,97,10,14,13,4,1,123,10,14,11,20,-0,-0,-0,-0,1,-101,8,1,427,19,3,1,226,19,13,1,7,18,1,-101,8,1,-16,17,1,32,1,-101,8,1,0,7,1,-100,8,1,444,19,1,111,15,-0,-0,2,1,427,19,3,1,162,19,5,1,10,10,13,9,1,111,16,1,-19,17,-0,-0,-0,-0,3,1,183,19,3,13,1,6,18,4,1,3,9,4,13,1,2,11,1,1,10,1,3,8,1,48,10,1,2,7,1,10,11,9,1,2,8,1,427,19,3,1,192,19,1,-22,18,1,2,7,1,3,7,11,1,454,19,1,0,3,1,2,8,1,3,8,1,111,15,-0,-0,-0,-0,1,65,10,1,397,9,7,1,454,19,1,104,15,-0,-0,-0,-0,9,14,16,3,17,19,6,21,-1,15,5,7,11,13,0,1,18,20,8,-1,10,2,4,-1,-1,-1,-0,-0,-0,-0,1,1,7,3,7,4,1,1,9,1,1,8,20,-0,-0,-0,-0,1,10,1,-101,8,20,-0,-0,-0,-0,1,0,7,4,5,8,1,1,9,1,0,8,20,-0,-0,-0,-0,2,1,1000,15,-0,-0,-0,-0,
}

for i, op in ipairs(program) do
    mem[i] = op
end

debug = false
intdebug = true

-- temporary solution until i implement file reading :)
strprg = [[]]
if strprg == "" then
    f = io.open("program.asm")
    x = ""
    while x ~= nil do
        strprg = strprg .. x
        x = f:read(128)
    end
end
for i = 1, #strprg do
    c = strprg:sub(i, i)
    setmem(i + 1000 - 1, string.byte(c))
end

pc = 0
halted = false





opcodenames = { "NOP", "PSH", "POP", "DUP", "SWP", "OVR", "ROT", "LDS", "STR", "ADD", "SUB", "MUL", "tfym", "NOT", "IBZ",
    "JMP", "CJP", "RJP", "RCJ", "CLL", "RET", "HLT" }
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
        push(a + b)
    end,
    function() -- 10 SUB
        a = pop()
        b = pop()
        push(b - a)
    end,
    function() -- 11 MUL
        a = pop()
        b = pop()
        push(a * b)
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
    --debug = pc >= 1000
    instruction = getmem(pc)
    if debug then
        print("pc:" .. pc .. ",executing instruction:" .. (opcodenames[instruction + 1] or instruction))
    end
    pc = pc + 1
    if instruction >= 0 and instruction <= #opcodes then
        opcodes[instruction + 1]()
    else
        halted = true
        print("CRASH! UNKNOWN INSTRUCTION '" .. instruction .. "'")
    end

    if debug then
        printstack()
        x = ""
        if intdebug then x = io.read() end
        if x == "m" then
            nmem = {}
            for i = 1, 4 do nmem[i] = getmem(i - 1) end
            for i = 1, 10 do nmem[i + 4] = getmem(i + 1000 - 1) end
            printarray(nmem, "mem vars")
        end
    end
end

print("bye!")
print("pc:" .. pc)
printstack()
-- io.read()
-- printarray(mem, "mem")
