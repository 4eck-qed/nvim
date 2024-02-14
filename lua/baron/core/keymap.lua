local keymap = {}

vim.g.mapleader = " "

-- Guidelines
--  normal mode:
--      prefer <leader> over <C-..>
--  insert mode:
--      functional keybinds with <C-..>
--
--  intuitive letters
--      e.g. fr = find references
--

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

-- key: string (=category) ; value: table (=keymaps=[key: string (=modes), value: table (=infos)]
baron.keymaps = {}

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

local echo = function(chunks)
    vim.api.nvim_echo(chunks, false, {})
end

--- Checks and writes collisions to keymaps
local function check_collisions()
    -- modes x [key x table{ plugin, action }]
    local buffer = {}
    -- go through plugins
    for plugin, kms in pairs(baron.keymaps) do
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
                    for _, info_ in ipairs(baron.keymaps[buffered.plugin][modes]) do
                        if info_.key == info.key then
                            info_.collisions = info_.collisions or {}

                            table.insert(info_.collisions, {
                                plugin = plugin,
                                action = info.action,
                            })
                        end
                    end
                else
                    buffer[modes][info.key] = {
                        plugin = plugin,
                        action = info.action,
                    }
                end
            end
        end
    end
end

--[[
    Global
]]

--- Sets a keymap.
--- Usage like from vim except additional category as first argument.
---@param category string Category
---@param modes string | table Modes
---@param key string Key
---@param action string | function Action
---@param options table Options
function keymap.set(category, modes, key, action, options)
    baron.keymaps[category] = baron.keymaps[category] or {}

    local modes_str = type(modes) == "table" and table.concat(modes, ",") or modes
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
        baron.keymaps[category][mode] = baron.keymaps[category][mode] or {}
        table.insert(baron.keymaps[category][mode], {
            modes = modes_str,
            key = key,
            action = action,
            options = options,
        })
    end

    vim.keymap.set(modes_tb, key, action, options)
end

--- Shows all keymaps
---@param filter table | nil list of keys
function show_keymaps(filter)
    if filter then
        echo({ { "Filter: ", "WarningMsg" }, { table.concat(filter, ", ") } })
    end

    check_collisions()

    -- sort by keys
    local keys = {}
    for k in pairs(baron.keymaps) do
        table.insert(keys, k)
    end
    table.sort(keys)

    for _, cat in ipairs(keys) do
        local map = baron.keymaps[cat]
        echo({ { cat, "Function" } })

        local col_w = 30
        local sep = " | "

        echo({ { pad("", col_w * 4, "-"), "Comment" } })
        local cols = {
            pad("Modes", 10, " "),
            pad("Keybind", col_w, " "),
            pad("Action", col_w, " "),
            pad("Description", col_w, " "),
        }

        local header = {}
        for i, col in ipairs(cols) do
            table.insert(header, { col, "Statement" })
            if i < #cols then
                table.insert(header, { sep, "Comment" })
            end
        end

        echo(header)

        for modes, infos in pairs(map) do
            local modes_hl
            if modes == "i" then
                modes_hl = "Structure"
            elseif modes == "n" then
                modes_hl = "Type"
            elseif modes == "v" then
                modes_hl = "Statement"
            end
            echo({ { pad(modes, 10, " "), modes_hl } })
            for _, info in ipairs(infos) do
                if filter and not tabelu.contains(filter, info.key) then
                    goto continue
                end

                local action = info.action
                local desc = info.options ~= nil and info.options.desc or ""
                if type(action) == "function" then
                    action = "<fn>"
                end
                action = stringu.limit(action, col_w)

                local key = info.key
                local key_hl
                -- local cls = ""
                if info.collisions then
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
                    { rpad("", 10, " "), nil },
                    { sep, "Comment" },
                    { rpad(key, col_w, " "), key_hl },
                    { sep, "Comment" },
                    { rpad(action, col_w, " "), nil },
                    { sep, "Comment" },
                    { rpad(desc, col_w, " "), "Identifier" },
                    -- { cls,                      "Error" }
                })

                ::continue::
            end
        end
        echo({ { pad("", col_w * 4, "-"), "Comment" } })
    end
end

function select_all()
    vim.cmd("normal gg")
    vim.cmd("normal V")
    vim.cmd("normal G")
end

--[[
    ///////////////////////////////////////
    ////////////    KEYMAPS   /////////////
    ///////////////////////////////////////
]]
local motions = { "", "w", "e", "$", "0", "gg", "G", "}" }
local text_objects = { "i(", "a(", "i[", "a[", "i{", "a{" }
local opt
local cat
--[[
    >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    >>>>>>>>>>>> BASICS >>>>>>>>>>>>
    >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
]]
cat = "Basics"

keymap.set(cat, "i", "<Esc>", "<Esc>", { desc = "enter normal mode" })
keymap.set(cat, "n", "<Esc>", "a", { desc = "enter insert mode" })
keymap.set(cat, "s", "<Esc>", "<C-g><Esc>", { desc = "leave selection mode" })
keymap.set(cat, { "i", "n", "v" }, "<C-S-Z>", "", { desc = "prevent suspend" })

opt = { desc = "force quit" }
keymap.set(cat, "i", "<C-q>", "<Esc>:q!<CR>", opt)
keymap.set(cat, { "n", "v" }, "<C-q>", ":q!<CR>", opt)

opt = { desc = "force quit all" }
keymap.set(cat, "i", "<C-S-q>", "<Esc>:qa!<CR>", opt)
keymap.set(cat, { "n", "v" }, "<C-S-q>", ":qa!<CR>", opt)

opt = { desc = "open terminal" }
keymap.set(cat, "i", "<C-t>", "<Esc>:term<CR>", opt)
keymap.set(cat, { "n", "v" }, "<C-t>", ":term<CR>", opt)

opt = { desc = "save document" }
keymap.set(cat, "i", "<C-s>", "<C-o>:w<CR>", opt)
keymap.set(cat, { "n", "v" }, "<C-s>", ":w<CR>", opt)

opt = { desc = "undo" }
keymap.set(cat, "i", "<C-z>", "<C-o>u", opt)
keymap.set(cat, { "n", "v" }, "<C-z>", "u", opt)

opt = { desc = "redo" }
keymap.set(cat, "i", "<C-y>", "<C-o><C-r>", opt)
keymap.set(cat, { "n", "v" }, "<C-y>", "<C-r>", opt)

keymap.set(cat, "n", "s", "*``", { desc = "highlight word under cursor" })

-- ###############################
-- # Copy, Cut, Paste, Duplicate #
opt = { desc = "copy" }
keymap.set(cat, "i", "<C-c>", "<C-o>y", opt)
keymap.set(cat, { "n", "v" }, "<C-c>", "y", opt)

opt = { desc = "cut" }
keymap.set(cat, "i", "<C-x>", "<C-o>dl", opt)
keymap.set(cat, { "n", "v" }, "x", "dl", opt)
keymap.set(cat, "v", "<C-x>", "dl", opt)

opt = { desc = "duplicate line(s)" }
keymap.set(cat, "i", "<C-d>", "<C-o>:t.<CR>", opt)
keymap.set(cat, { "n", "v" }, "<C-d>", ":t.<CR>", opt)
-- keymaps.set(cat,"v", "<C-d>", ":'<,'>t.<cr>", { desc = "duplicate line(s)" })

opt = { desc = "paste" }
keymap.set(cat, "i", "<C-v>", "<C-r>+", opt)
keymap.set(cat, "n", "<C-v>", "p", opt)

opt = { desc = "paste, replacing selected text without copying it" }
keymap.set(cat, "v", "<C-v>", '"_dP', opt)
keymap.set(cat, "v", "<C-S-v>", '"_dP', opt)

-- ###############################

--[[
    >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    >>>>>>>>> MANIPULATION >>>>>>>>>
    >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
]]
cat = "Manipulation"

-- #################################
-- #            Delete             #
opt = { desc = "delete line(s)" }
keymap.set(cat, "i", "<S-Del>", "<C-o>dd", opt)
keymap.set(cat, { "n", "v" }, "<S-Del>", "dd", opt)

opt = { desc = "delete word to right" }
keymap.set(cat, "i", "<C-Del>", "<C-o>dw", opt)
keymap.set(cat, { "n", "v" }, "<C-Del>", "dw", opt)

opt = { desc = "delete word to the left" }
keymap.set(cat, "i", "<C-BS>", "<C-w>", opt)
keymap.set(cat, "n", "<C-BS>", "db", opt)
keymap.set(cat, "v", "<C-BS>", ":<C-u>normal! db<CR>", opt)

keymap.set(cat, "n", "d", "_d", { desc = "delete character under cursor" })
keymap.set(cat, "v", "<BS>", "d", { desc = "delete character to the left" })
-- #################################

keymap.set(cat, "v", "<", "<gv", { desc = "Unindent & stay in visual mode" })
keymap.set(cat, "v", ">", ">gv", { desc = "Indent & stay in visual mode" })

opt = { desc = "move line(s) up" }
keymap.set(cat, "i", "<A-Up>", "<C-o>:move -2<CR>", opt)
keymap.set(cat, "n", "<A-Up>", ":move -2<CR>", opt)
keymap.set(cat, "v", "<A-Up>", ":move '<-2<CR>gv", opt)

opt = { desc = "move line(s) down" }
keymap.set(cat, "i", "<A-Down>", "<C-o>:move +1<CR>", opt)
keymap.set(cat, "n", "<A-Down>", ":move +1<CR>", opt)
keymap.set(cat, "v", "<A-Down>", ":move '>+1<CR>gv", opt)
--[[
    >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    >>>>>>>>>> NAVIGATION >>>>>>>>>>
    >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
]]
cat = "Navigation"

opt = { desc = "goto line start" }
keymap.set(cat, "i", "<C-a>", "<C-o>^", opt)
keymap.set(cat, { "n", "v" }, "<C-a>", "^", opt)

opt = { desc = "goto line end" }
keymap.set(cat, "i", "<C-e>", "<C-o>$", opt)
keymap.set(cat, { "n", "v" }, "<C-e>", "$", opt)

opt = { desc = "skip word left" }
keymap.set(cat, "i", "<C-Left>", "<Esc>bi", opt)
keymap.set(cat, "n", "<C-Left>", "b", opt)

opt = { desc = "skip word right" }
keymap.set(cat, "i", "<C-Right>", "<Esc>ea", opt)
keymap.set(cat, "n", "<C-Right>", "e", opt)

keymap.set(cat, "n", "<leader>b", ":bprev<CR>", { desc = "prev buffer" })
keymap.set(cat, "n", "<leader>+", "<C-a>", { desc = "incr number" })
keymap.set(cat, "n", "<leader>-", "<C-x>", { desc = "decr number" })
keymap.set(cat, "n", "<leader>cm", ":nohl<CR>", { desc = "clear search matches" })

-- window splitting
keymap.set(cat, "n", "<leader>sv", "<C-w>v", { desc = "vertical split" })
keymap.set(cat, "n", "<leader>sh", "<C-w>s", { desc = "horizontal split" })
keymap.set(cat, "n", "<leader>se", "<C-w>=", { desc = "equal split" })
keymap.set(cat, "n", "<leader>sx", ":close<CR>", { desc = "close split" })

-- tabs
keymap.set(cat, "n", "<leader>to", ":tabnew<CR>", { desc = "open new tab" })
keymap.set(cat, "n", "<leader>tx", ":tabclose<CR>", { desc = "close tab" })
keymap.set(cat, "n", "<leader>tn", ":tabn<CR>", { desc = "goto next tab" })
keymap.set(cat, "n", "<leader>tp", ":tabp<CR>", { desc = "goto prev tab" })

--[[
    >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    >>>>>>>>>> SELECTION >>>>>>>>>>>
    >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
]]
cat = "Selection"
opt = { desc = "select line up" }
keymap.set(cat, "i", "<S-Up>", "<Esc>Vk", opt)
keymap.set(cat, "n", "<S-Up>", "Vk", opt)
keymap.set(cat, "v", "<S-Up>", "k", opt)

opt = { desc = "select line down" }
keymap.set(cat, "i", "<S-Down>", "<Esc>Vj", opt)
keymap.set(cat, "n", "<S-Down>", "Vj", opt)
keymap.set(cat, "v", "<S-Down>", "j", opt)

opt = { desc = "select page up" }
keymap.set(cat, "i", "<S-C-Up>", "<C-o>v<PageUp>", opt)
keymap.set(cat, "n", "<S-C-Up>", "v<PageUp>", opt)
keymap.set(cat, "v", "<S-C-Up>", "<PageUp>", opt)

opt = { desc = "select page down" }
keymap.set(cat, "i", "<S-C-Down>", "<C-o>v<PageDown>", opt)
keymap.set(cat, "n", "<S-C-Down>", "v<PageDown>", opt)
keymap.set(cat, "v", "<S-C-Down>", "<PageDown>", opt)

opt = { desc = "select to the left" }
keymap.set(cat, "i", "<S-Left>", "<C-o>vh", opt)
keymap.set(cat, "n", "<S-Left>", "vh", opt)
keymap.set(cat, "v", "<S-Left>", "h", opt)

opt = { desc = "select page down" }
keymap.set(cat, "i", "<S-Right>", "<C-o>vl", opt)
keymap.set(cat, "n", "<S-Right>", "vl", opt)
keymap.set(cat, "v", "<S-Right>", "l", opt)

opt = { desc = "select to the left with skip" }
keymap.set(cat, "i", "<S-C-Left>", "<C-o>v<C-Left>", opt)
keymap.set(cat, "n", "<S-C-Left>", "v<C-Left>", opt)
keymap.set(cat, "v", "<S-C-Left>", "<C-Left>", opt)

opt = { desc = "select to the right with skip" }
keymap.set(cat, "i", "<S-C-Right>", "<C-o>v<C-Right>", opt)
keymap.set(cat, "n", "<S-C-Right>", "v<C-Right>", opt)
keymap.set(cat, "v", "<S-C-Right>", "<C-Right>", opt)

opt = { desc = "Select all" }
keymap.set(cat, "i", "<C-S-a>", "<C-o>:lua select_all()<CR>l", opt)
keymap.set(cat, "n", "<leader>a", ":lua select_all()<CR>", opt)

return keymap
