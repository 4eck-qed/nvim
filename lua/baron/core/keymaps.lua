local keymaps = {}

-- keymap info:
-- {
--      modes: string
--      key: string
--      action: string
--      options: table
--      [collisions: table]
-- }

-- collision
-- {
--      plugin: string
--      action: string
-- }

-- key: string = modes ; value: table = infos
baron.keymaps = {}

-- key: string (=plugin) ; value: table (=keymaps=[key: string (=modes), value: table (=infos)]
baron.keymaps_plugins = {}

vim.g.mapleader = ' '

--[[
    /////////////////////////////////
    //////////// FUNCS  /////////////
    /////////////////////////////////
]]
require("baron.core.functions")
local stringu = require("baron.core.utils.str")
local tabelu = require("baron.core.utils.tb")

--[[
    Local
--]]

local function echo(chunks)
    vim.api.nvim_echo(chunks, false, {})
end

local function _set(modes, key, action, options, is_operation)
    for mode in modes:gmatch("[^,]+") do
        baron.keymaps[mode] = baron.keymaps[mode] or {}

        if mode == "i" and is_operation then
            local operation = "<C-o>" .. action
            table.insert(baron.keymaps[mode], {
                modes = mode,
                key = key,
                action = operation,
                options = options,
            })
            vim.keymap.set(mode, key, operation, options)
        else
            table.insert(baron.keymaps[mode], {
                modes = mode,
                key = key,
                action = action,
                options = options,
            })
            vim.keymap.set(mode, key, action, options)
        end
    end
end

-- checks and writes collisions to keymaps
local function check_collisions()
    -- modes x [key x table{ plugin, action }]
    local buffer = {}
    -- go through plugins
    for plugin, kms in pairs(baron.keymaps_plugins) do
        -- go through modes
        for modes, infos in pairs(kms) do
            buffer[modes] = buffer[modes] or {}

            -- go through infos
            for _, info in ipairs(infos) do
                if buffer[modes][info.key] ~= nil then
                    info.collisions = info.collisions or {}

                    local buffered = buffer[modes][info.key]

                    table.insert(info.collisions, buffered)

                    -- add collision to the one that was buffered
                    for _, info_ in ipairs(baron.keymaps_plugins[buffered.plugin][modes]) do
                        if info_.key == info.key then
                            info_.collisions = info_.collisions or {}

                            table.insert(info_.collisions, {
                                plugin = plugin,
                                action = info.action
                            })
                        end
                    end
                else
                    buffer[modes][info.key] = {
                        plugin = plugin,
                        action = info.action
                    }
                end
            end
        end
    end
end

local function _show_keymaps(title, kms, filter_keys)
    check_collisions()
    echo({ { title, "Function" } })

    local col_w = 30
    local sep = " | "

    -- local sorted = {}
    -- for modes, infos in pairs(keymaps) do
    --     table.insert(sorted, infos)
    -- end

    -- table.sort(sorted, function(entry1, entry2)
    --     -- Split modes into tables for comparison
    --     local modes1 = {}
    --     local modes2 = {}
    --
    --     for mode in entry1.modes:gmatch("[^,]+") do
    --         table.insert(modes1, mode)
    --     end
    --
    --     for mode in entry2.modes:gmatch("[^,]+") do
    --         table.insert(modes2, mode)
    --     end
    --
    --     -- Compare modes lexicographically
    --     for i = 1, math.min(#modes1, #modes2) do
    --         if modes1[i] < modes2[i] then
    --             return true
    --         elseif modes1[i] > modes2[i] then
    --             return false
    --         end
    --     end
    --
    --     -- If modes are equal up to this point, compare by key
    --     if #modes1 < #modes2 then
    --         return true
    --     elseif #modes1 > #modes2 then
    --         return false
    --     else
    --         return entry1.key < entry2.key
    --     end
    -- end)

    echo({ { pad('', col_w * 4, '-'), "Comment" } })
    local cols = {
        pad("Modes", 10, ' '),
        pad("Keybind", col_w, ' '),
        pad("Action", col_w, ' '),
        pad("Description", col_w, ' '),
    }

    local header = {}
    for i, col in ipairs(cols) do
        table.insert(header, { col, "Statement" })
        if i < #cols then
            table.insert(header, { sep, "Comment" })
        end
    end

    echo(header)

    for modes, infos in pairs(kms) do
        local modes_hl
        if modes == "i" then
            modes_hl = "Structure"
        elseif modes == "n" then
            modes_hl = "Type"
        elseif modes == "v" then
            modes_hl = "Statement"
        end
        echo({ { pad(modes, 10, ' '), modes_hl } })
        for i, v in ipairs(infos) do
            if filter_keys and not tabelu.contains(filter_keys, v.key) then
                goto continue
            end

            local action = v.action
            local desc = v.options ~= nil and v.options.desc or nil
            if type(action) == "function" then
                action = "<fn>"
            end
            action = stringu.limit(action, col_w)

            local key = v.key
            local key_hl
            -- local cls = ""
            if v.collisions then
                -- cls = "collides with: "
                -- for i, collision in ipairs(v.collisions) do
                --     cls = cls .. collision.plugin
                --     if i < #v.collisions then
                --         cls = cls .. ","
                --     end
                -- end
                key_hl = "Error"
            end

            echo({
                { rpad('', 10, ' '),        nil },
                { sep,                      "Comment" },
                { rpad(key, col_w, ' '),    key_hl },
                { sep,                      "Comment" },
                { rpad(action, col_w, ' '), nil },
                { sep,                      "Comment" },
                { rpad(desc, col_w, ' '),   "Identifier" },
                -- { cls,                      "Error" }
            })

            ::continue::
        end
    end
    echo({ { pad('', col_w * 4, '-'), "Comment" } })
end

local function vmap_xmode(key, action, options)
    _set("i", key, "<C-o>v" .. action, options)
    _set("n", key, "v" .. action, options)
    _set("v", key, action, options)
end

local function map_leader(key, action, options)
    key = "<leader>" .. key
    _set("n", key, action, options)
end


--[[
    Global
]]

--- Sets a keymap.
---@param plugin string Name of the plugin
---@param modes string | table Modes
---@param key string Key
---@param action string | function Action
---@param options table Options
function keymaps.set(plugin, modes, key, action, options)
    baron.keymaps_plugins[plugin] = baron.keymaps_plugins[plugin] or {}

    local modes_str = type(modes) == "table" and table.concat(modes, ',') or modes
    local modes_tb = {}

    -- Convert `i,n,v` to `{'i', 'n', 'v'}`
    if type(modes) == "string" then
        for mode in modes:gmatch("[^,]+") do
            table.insert(modes_tb, mode)
        end
    else
        modes_tb = modes
    end

    -- insert into cheat sheet
    for _, mode in ipairs(modes_tb) do
        baron.keymaps_plugins[plugin][mode] = baron.keymaps_plugins[plugin][mode] or {}
        table.insert(baron.keymaps_plugins[plugin][mode], {
            modes = modes_str,
            key = key,
            action = action,
            options = options,
        })
    end

    vim.keymap.set(modes_tb, key, action, options)
end

--- Shows all keymaps
---@param filter_keys table | nil list of keys
function show_keymaps(filter_keys)
    if filter_keys then
        echo({ { "Filter: ", "WarningMsg" }, { table.concat(filter_keys, ', ') } })
    end
    _show_keymaps("Core", baron.keymaps, filter_keys)
    for k, v in pairs(baron.keymaps_plugins) do
        _show_keymaps(k, v, filter_keys)
    end
end

--[[
    ///////////////////////////////////////
    ////////////    KEYMAPS   /////////////
    ///////////////////////////////////////
]]

local motions = { "", "w", "e", "$", "0", "gg", "G", "}" }
local text_objects = { "i(", "a(", "i[", "a[", "i{", "a{" }
--[[
    >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    >>>>>>>>>>>>    X   >>>>>>>>>>>>
    >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
]]
_set("i,n,v", '<C-S-Z>', '', { desc = 'Prevent suspend' }, true)
_set("i,n,v", '<C-q>', ':q!<CR>', { desc = 'force quit' }, true)
_set("i,n,v", '<C-S-q>', ':qa!<CR>', { desc = 'force quit all' }, true)
_set("i,n,v", '<C-t>', ':term<CR>', { desc = 'open terminal' }, true)
_set("i,n,v", '<C-s>', ':w<CR>', { desc = 'save document' }, true)
_set("i,n,v", '<C-z>', 'u', { desc = 'undo' }, true)
_set("i,n,v", '<C-y>', '<C-r>', { desc = 'redo' }, true)
_set("i,n,v", '<C-a>', '^', { desc = 'goto line start' }, true)
_set("i,n,v", '<C-e>', '<End>', { desc = 'goto line end' }, true)
_set("i,n,v", '<S-Del>', 'dd', { desc = 'delete line(s)' }, true)
_set("i,n,v", '<C-Del>', 'dw', { desc = 'delete word to right' }, true)
_set("i,n,v", '<C-x>', 'd', { desc = 'cut' }, true)
_set("i,n,v", '<C-c>', 'y', { desc = 'copy' }, true)
_set("i,n,v", '<C-d>', ':t.<CR>', { desc = 'duplicate line' }, true)

-- Selection
vmap_xmode('<S-Up>', 'k', { desc = 'select up' })
vmap_xmode('<S-Down>', 'j', { desc = 'select down' })
vmap_xmode('<S-C-Up>', '<PageUp>', { desc = 'select page up' })
vmap_xmode('<S-C-Down>', '<PageDown>', { desc = 'select page down' })
vmap_xmode('<S-Left>', 'h', { desc = 'select to the left' })
vmap_xmode('<S-Right>', 'l', { desc = 'select to the right' })
vmap_xmode('<S-C-Left>', '<C-Left>', { desc = 'select to the left with skip' })
vmap_xmode('<S-C-Right>', '<C-Right>', { desc = 'select to the right with skip' })

--[[
    >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    >>>>>>>>>>>> NORMAL >>>>>>>>>>>>
    >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
]]
_set("n", '<C-BS>', 'db', { desc = 'delete word to left' })
_set("n", '<C-v>', 'p', { desc = 'paste' })
_set("n", "s", "*``v<C-g>", { desc = "Enter selection mode" })
_set("n", "x", "dl", { desc = "Cut character under cursor" })
_set("n", "d", "_d", { desc = "Delete character under cursor" })
_set("n", '<Esc>', 'a', { desc = "Enter insert mode" })
_set("n", '<C-Left>', 'b', { desc = 'skip word left' })
_set("n", '<C-Right>', 'e', { desc = 'skip word right' })
_set("n", '<A-Up>', ':move -2<CR>', { desc = 'move line(s) up' })
_set("n", '<A-Down>', ':move +1<CR>', { desc = 'move line(s) down' })
map_leader('b', ':bprev<CR>', { desc = 'prev buffer' })
map_leader('+', '<C-a>', { desc = 'incr number' })
map_leader('-', '<C-x>', { desc = 'decr number' })
map_leader('cm', ':nohl<CR>', { desc = 'clear search matches' })

-- window splitting
map_leader('sv', '<C-w>v', { desc = 'vertical split' })
map_leader('sh', '<C-w>s', { desc = 'horizontal split' })
map_leader('se', '<C-w>=', { desc = 'equal split' })
map_leader('sx', ':close<CR>', { desc = 'close split' })

-- tabs
map_leader('to', ':tabnew<CR>', { desc = 'open new tab' })
map_leader('tx', ':tabclose<CR>', { desc = 'close tab' })
map_leader('tn', ':tabn<CR>', { desc = 'goto next tab' })
map_leader('tp', ':tabp<CR>', { desc = 'goto prev tab' })

--[[
    >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    >>>>>>>>>>>> VISUAL >>>>>>>>>>>>
    >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
]]
_set("v", '<C-BS>', ':<C-u>normal! db<CR>', { desc = 'delete word to left' })
_set("v", '<C-v>', '\"_dP', { desc = 'paste, replacing selected text without copying it' })
_set("v", '<C-S-v>', '\"_dP', { desc = 'paste, replacing selected text without copying it' })
_set("v", '<BS>', 'd', { desc = 'delete backward' })
_set("v", "<", "<gv", { desc = "Unindent & stay in visual mode" })
_set("v", ">", ">gv", { desc = "Indent & stay in visual mode" })
_set("v", '<C-d>', ':\'<,\'>t.<cr>', { desc = 'duplicate line(s)' })
_set("v", '<A-Down>', ':move \'>+1<CR>gv', { desc = 'move line(s) down' })
_set("v", '<A-Up>', ':move \'<-2<CR>gv', { desc = 'move line(s) up' })
_set("s", "<Esc>", "<C-g><Esc>", { desc = "Leave selection mode" })

--[[
    >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    >>>>>>>>>>>> INSERT >>>>>>>>>>>>
    >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
]]
_set("i", '<Esc>', '<Esc>', { desc = "Enter normal mode" })
_set("i", '<C-e>', '<End>', { desc = "Move to end of line" })
_set("i", '<C-BS>', '<C-w>', { desc = 'delete word to left' })
_set("i", '<C-Left>', '<Esc>bi', { desc = 'skip word left' })
_set("i", '<C-Right>', '<Esc>ea', { desc = 'skip word right' })
_set("i", '<A-Up>', '<C-o>:move -2<CR>', { desc = 'move line(s) up' })
_set("i", '<A-Down>', '<Esc>:move +1<CR>i', { desc = 'move line(s) down' })
_set("i", '<C-v>', '<C-r>+', { desc = 'paste' })
_set("i", '<Space>', ' ')
_set("i", '<C-Bslash>', '<Esc><S-k>')

return keymaps
