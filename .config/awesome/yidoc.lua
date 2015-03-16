local awful     = require("awful")
local naughty   = require("naughty")
local string    = string
local math      = math
local pairs     = pairs
local ipairs    = ipairs
local tostring  = tostring
local table     = table
local io        = io

local maxlen = 0
module("yidoc")

local nid = nil

-- trim left/right spaces
local function trim(str)
  local r,_ = str:gsub("^%s*(.-)%s*$", "%1")
  return r
end

-- Unicode "aware" length function (well, UTF8 aware)
-- See: http://lua-users.org/wiki/LuaUnicode
local function unilen(str)
   local _, count = string.gsub(str, "[^\128-\193]", "")
   return count
end

function parse(fname)
  local fh = io.open(fname)
  local order  = {}
  local result = {}
  maxlen = 0
  local title = ""
  for line in fh:lines() do
    if string.find(line, "==") then
      local s,_ = string.gsub(line, "==", "")
      title = trim(s)
      order[#order+1] = title
      result[title] = {}
    else
      local pos = string.find(line, "-")
      if pos then
        local left = trim(string.sub(line, 1, pos-1))
        maxlen = math.max(maxlen, unilen(left))
        local right = trim(string.sub(line, pos+1))
        local grp = result[title]
        grp[#grp+1] = {
          key = left,
          doc = right
        }
      end
    end
  end
  fh:close()
  return order,result
end

local function markup(order, keydocs, opt)
  local result = {}
  for _,title in ipairs(order) do
    local grp = keydocs[title]
    result[#result + 1] = '<span color="' .. opt.title_fg .. '"><b>' .. title .. '</b></span>'
    for _,keydoc in ipairs(grp) do
      result[#result + 1] = 
        '<span color="' .. opt.key_fg .. '">' ..
        string.format("%" .. (maxlen - unilen(keydoc.key)) .. "s  ", "") .. keydoc.key ..
        '</span>  <span color="' .. opt.doc_fg .. '">' ..
        keydoc.doc .. '</span>'
    end
  end
  return result
end

function display(fname, opt)
  opt.title_fg = opt.title_fg or "#EA6F81"
  opt.key_fg   = opt.key_fg   or "#D8D782"
  opt.doc_fg   = opt.doc_fg   or "white"
  opt.font     = opt.font     or "Dejavu Sans Mono 10"
  opt.opacity  = opt.opacity  or 0.9

  local ord,docs = parse(fname)
  local lines = markup(ord, docs, opt)
  local result = ""
  for _,line in pairs(lines) do
    result = result .. line .. '\n'
  end

  nid = naughty.notify({
    text = result,
    replaces_id = nid,
    hover_timeout = 0.1,
    timeout = 10,
    font = opt.font,
    opacity = opt.opacity,
  }).nid
end
