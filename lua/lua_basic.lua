print("Hello Lua!")

-- 单行注释

--[[
  多行注释
--]]

-- nil
local b = nil
print(b)


print(type("Hello world"))      --> string
print(type(10.4*3))             --> number
print(type(print))              --> function
print(type(type))               --> function
print(type(true))               --> boolean
print(type(nil))                --> nil
print(type(type(X)))            --> string

-- nil 还有一个"删除"作用，给全局变量或者 table 表里的变量赋一个 nil 值，等同于把它们删掉
local tab1 = { key1 = "val1", key2 = "val2", "val3" }
for k, v in pairs(tab1) do
    print(k .. " - " .. v)
end

--tab1 = nil
for k, v in pairs(tab1) do
    print(k .. " - " .. v)
end

--可以用 2 个方括号 "[[]]" 来表示"一块"字符串

local html = [[
<html>
<head></head>
<body>
    <a href="http://www.abc.com/">abc</a>
</body>
</html>
]]
print(html)

-- 对一个数字字符串上进行算术操作时，Lua 会尝试将这个数字字符串转成一个数字
print("2" + 6)
-->8.0
print("2" + "6")
-->8.0

-- 使用 # 来计算字符串的长度，放在字符串前面
local str = "我是几个字符123"
print(#str)

-- Lua 中的表（table）其实是一个"关联数组"（associative arrays），数组的索引可以是数字或者是字符串
local a = {}
a["key"] = "value"
local key = 10
a[key] = 22
a[key] = a[key] + 11
for k, v in pairs(a) do
    print(k .. " : " .. v)
end

-- 不同于其他语言的数组把 0 作为数组的初始索引，在 Lua 里表的默认初始索引一般以 1 开始。

local tbl = {"apple", "pear", "orange"}
for key1, val in pairs(tbl) do
    print("Key", key1)
end
--> Key     1
--> Key     2
--> Key     3

-- 在 Lua 中，函数是被看作是"第一类值（First-Class Value）"，函数可以存在变量里:
function factorial1(n)
    if n == 0 then
        return 1
    else
        return n * factorial1(n - 1)
    end
end
print(factorial1(5))
factorial2 = factorial1
print(factorial2(5))

-- 全局变量(全局变量建议 大写开头)局部变量
A = 5               -- 全局变量
local b = 5         -- 局部变量

function Joke()
    C = 5           -- 全局变量
    local d = 6     -- 局部变量
end

Joke()
print(C,d)          --> 5 nil

-- 循环
local i = 1
while( i<10 )
do
   print("while循环,i = ", i)
   i = i+1
end

--[[
    for var=exp1,exp2,exp3 do  
    <执行体>  
    end
    -- var 从 exp1 变化到 exp2，每次变化以 exp3 为步长递增 var，并执行一次 "执行体"。
    -- exp3 是可选的，如果不指定，默认为1。
--]]

for i=10,1,-1 do
    print(i)
end 

-- 条件控制

if(0)
then
    print("0 为 true")
end

-- 不等于 ~=
-- .. 连接符
-- # 计算字符串长度，或者数组长度

-- string.gsub(mainString,findString,replaceString,num)
-- string.find (str, substr, [init, [end]])
-- string.format(...) 返回一个类似printf的格式化字符串
-- 日期格式化
date = 2; month = 1; year = 2014
print(string.format("日期格式化 %02d/%02d/%03d", date, month, year))
-- string.sub(s, i [, j]) 用于截取字符串。s：要截取的字符串，i：截取开始位置。j：截取结束位置，默认为 -1，最后一个字符。

-- 泛型 for 迭代器
array = {"Google", "Runoob"}

for key,value in ipairs(array)
do
   print(key, value)
end