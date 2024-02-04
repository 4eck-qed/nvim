local utils = {}

function utils.is_windows()
    return package.config:sub(1, 1) == "\\"
end


function utils.call_each(f, args)
    for i, v in ipairs(args) do
        f(v)
    end
end

function utils.list_append(list1, list2)
    for _, v in ipairs(list2) do
        table.insert(list1, v)
    end
end

return utils

