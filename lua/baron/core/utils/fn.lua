local fn = {}

function fn.call_each(f, args)
    for i, v in ipairs(args) do
        f(v)
    end
end

return fn
