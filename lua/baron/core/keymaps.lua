baron_keymaps = {}

vim.g.mapleader = ' '

--[[
    /////////////////////////////////
    //////////// FUNCS  /////////////
    /////////////////////////////////
]]
require("baron.core.functions")

function show_keymaps()
    print("Custom Keymaps(" .. len(baron_keymaps) .. "):")

    col_w = 30
    sep = " | "

    local sorted = {}
    for k, v in pairs(baron_keymaps) do
        v.key = k
        table.insert(sorted, v)
    end

    table.sort(sorted, function(entry1, entry2)
        -- Split modes into tables for comparison
        local modes1 = {}
        local modes2 = {}

        for mode in entry1.modes:gmatch("[^,]+") do
            table.insert(modes1, mode)
        end

        for mode in entry2.modes:gmatch("[^,]+") do
            table.insert(modes2, mode)
        end

        -- Compare modes lexicographically
        for i = 1, math.min(#modes1, #modes2) do
            if modes1[i] < modes2[i] then
                return true
            elseif modes1[i] > modes2[i] then
                return false
            end
        end

        -- If modes are equal up to this point, compare by key
        if #modes1 < #modes2 then
            return true
        elseif #modes1 > #modes2 then
            return false
        else
            return entry1.key < entry2.key
        end
    end)

    print(pad('', col_w * 4, '-'))
    col1 = pad("Modes", 10, ' ')
    col2 = pad("Keybind", col_w, ' ')
    col3 = pad("Action", col_w, ' ')
    col4 = pad("Help", col_w, ' ')
    print(col1 .. sep .. col2 .. sep .. col3 .. sep .. col4)
    for k, v in pairs(sorted) do
        print(
            rpad(v.modes, 10, ' ') .. sep ..
            rpad(v.key, col_w, ' ') .. sep ..
            rpad(v.action, col_w, ' ') .. sep ..
            rpad(v.help, col_w, ' ')
        )
    end
    print(pad('', col_w * 4, '-'))
end

local function unset(key)
    pcall(vim.keymap.del, 'i', key)
    pcall(vim.keymap.del, 'n', key)
    pcall(vim.keymap.del, 'v', key)
end

local function format_help(modes, action, help)
    return string.format("[%s] %s (%s)", modes, action, help)
end

local function map_xmode_uniform(key, cmd, help)
    baron_keymaps[key] = {
        modes = "i,n,v",
        action = cmd,
        help = help,
    }

    vim.keymap.set('i', key, cmd)
    vim.keymap.set('n', key, cmd)
    vim.keymap.set('v', key, cmd)
end

local function cmd_xmode(key, cmd, help)
    baron_keymaps[key] = {
        modes = "i,n,v",
        action = cmd,
        help = help,
    }

    vim.keymap.set('i', key, string.format('<C-o>%s<CR>', cmd))
    vim.keymap.set('n', key, string.format('%s<CR>', cmd))
    vim.keymap.set('v', key, string.format('%s<CR>', cmd))
end

local function map_xmode(key, map, help)
    baron_keymaps[key] = {
        modes = "i,n,v",
        action = map,
        help = help,
    }

    vim.keymap.set('i', key, string.format('<C-o>%s', map))
    vim.keymap.set('n', key, string.format('%s', map))
    vim.keymap.set('v', key, string.format('%s', map))
end

local function vcmd_xmode(key, cmd, help)
    baron_keymaps[key] = {
        modes = "i,n,v",
        action = cmd,
        help = help,
    }

    vim.keymap.set('i', key, string.format('<C-o>v%s<CR>', cmd))
    vim.keymap.set('n', key, string.format('v%s<CR>', cmd))
    vim.keymap.set('v', key, string.format('%s<CR>', cmd))
end

local function vmap_xmode(key, map, help)
    baron_keymaps[key] = {
        modes = "i,n,v",
        action = map,
        help = help,
    }

    vim.keymap.set('i', key, string.format('<C-o>v%s', map))
    vim.keymap.set('n', key, string.format('v%s', map))
    vim.keymap.set('v', key, string.format('%s', map))
end

local function cmd_nv(key, cmd, help)
    baron_keymaps[key] = {
        modes = "n,v",
        action = cmd,
        help = help,
    }

    vim.keymap.set('n', key, string.format('%s<CR>', cmd))
    vim.keymap.set('v', key, string.format('%s<CR>', cmd))
end

local function map_i(key, map, help)
    baron_keymaps[key] = {
        modes = "i",
        action = map,
        help = help,
    }

    vim.keymap.set('i', key, map)
end

local function map_n(key, map, help)
    baron_keymaps[key] = {
        modes = "n",
        action = map,
        help = help,
    }

    vim.keymap.set('n', key, map)
end

local function map_v(key, map, help)
    baron_keymaps[key] = {
        modes = "v",
        action = map,
        help = help,
    }

    vim.keymap.set('v', key, map)
end

local function map_nv(key, map, help)
    baron_keymaps[key] = {
        modes = "n,v",
        action = map,
        help = help,
    }

    vim.keymap.set('n', key, map)
    vim.keymap.set('v', key, map)
end

local function cmd_leader(key, cmd, help)
    key = "<leader>" .. key
    baron_keymaps[key] = {
        modes = "n",
        action = cmd,
        help = help,
    }

    vim.keymap.set('n', key, string.format('%s<CR>', cmd))
end

local function map_leader(key, map, help)
    key = "<leader>" .. key
    baron_keymaps[key] = {
        modes = "n",
        action = map,
        help = help,
    }

    vim.keymap.set('n', key, map)
end

--[[
    /////////////////////////////////
    ////////////    X   /////////////
    /////////////////////////////////
]]
-- Basics
map_i('<Esc>', '<Esc>', 'enter normal mode')
map_n('<Esc>', 'a', 'enter insert mode')
map_xmode('<C-S-Z>', '', 'Prevent suspend')
cmd_xmode('<C-q>', ':q!', 'force quit')
cmd_xmode('<C-S-q>', ':qa!', 'force quit all')
cmd_xmode('<C-t>', ':term', 'open terminal')
cmd_xmode('<C-s>', ':w', 'save document')
map_xmode('<C-z>', 'u', 'undo')
map_xmode('<C-y>', '<C-r>', 'redo')

-- Selection
vmap_xmode('<S-Up>', 'k', 'select up')
vmap_xmode('<S-Down>', 'j', 'select down')
vmap_xmode('<S-C-Up>', '<PageUp>', 'select page up')
vmap_xmode('<S-C-Down>', '<PageDown>', 'select page down')
vmap_xmode('<S-Left>', 'h', 'select to the left')
vmap_xmode('<S-Right>', 'l', 'select to the right')
vmap_xmode('<S-C-Left>', '<C-Left>', 'select to the left with skip')
vmap_xmode('<S-C-Right>', '<C-Right>', 'select to the right with skip')

-- Navigation
map_xmode('<C-a>', '^', 'goto line start')
map_xmode('<C-e>', '<End>', 'goto line end')
map_i('<C-Left>', '<Esc>bi', 'skip word left')
map_n('<C-Left>', 'b', 'skip word left')
map_i('<C-Right>', '<Esc>ea', 'skip word right')
map_n('<C-Right>', 'e', 'skip word right')

-- Move line(s) up
map_i('<A-Up>', '<C-o>:move -2<CR>', 'move line(s) up')
map_n('<A-Up>', ':move -2<CR>', 'move line(s) up')
map_v('<A-Up>', ':move \'<-2<CR>gv', 'move line(s) up')

-- Move line(s) down
map_i('<A-Down>', '<Esc>:move +1<CR>i', 'move line(s) down')
map_n('<A-Down>', ':move +1<CR>', 'move line(s) down')
map_v('<A-Down>', ':move \'>+1<CR>gv', 'move line(s) down')

-- Delete
map_xmode('<S-Del>', 'dd', 'delete line(s)')
map_i('<C-BS>', '<C-w>', 'delete word to left')
map_nv('<C-BS>', 'db', 'delete word to left')
map_xmode('<C-Del>', 'dw', 'delete word to right')

-- Copy, Paste, Duplicate
map_xmode('<C-x>', 'd', 'cut')
map_xmode('<C-c>', 'y', 'copy')
map_nv('<C-v>', 'p', 'paste')
map_i('<C-v>', '<C-r>+', 'paste')
cmd_xmode('<C-d>', ':t.', 'duplicate line')
map_v('<C-d>', ':\'<,\'>t.<cr>', 'duplicate line(s)')

--[[
    /////////////////////////////////
    //////////// NORMAL /////////////
    /////////////////////////////////
]]
map_n('x', '\'_x', 'delete char no copy')
cmd_leader('b', ':bprev', 'prev buffer')
map_leader('+', '<C-a>', 'incr number')
map_leader('-', '<C-x>', 'decr number')
cmd_leader('cm', ':nohl', 'clear search matches')

-- window splitting
map_leader('sv', '<C-w>v', 'vertical split')
map_leader('sh', '<C-w>s', 'horizontal split')
map_leader('se', '<C-w>=', 'equal split')
cmd_leader('sx', ':close', 'close split')

-- tabs
cmd_leader('to', ':tabnew', 'open new tab')
cmd_leader('tx', ':tabclose', 'close tab')
cmd_leader('tn', ':tabn', 'goto next tab')
cmd_leader('tp', ':tabp', 'goto prev tab')

--[[
    /////////////////////////////////
    //////////// VISUAL /////////////
    /////////////////////////////////
]]
map_v('<BS>', 'd', 'delete backward')
map_v("<", "<gv", "Unindent & stay in visual mode");
map_v(">", ">gv", "Indent & stay in visual mode");

--[[
    /////////////////////////////////
    //////////// INSERT /////////////
    /////////////////////////////////
]]
map_i('<Space>', ' ')
map_i('<C-Bslash>', '<Esc><S-k>')
