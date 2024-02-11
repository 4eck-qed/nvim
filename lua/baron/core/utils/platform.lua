local platform = {}

function platform.is_windows()
    return package.config:sub(1, 1) == "\\"
end

return platform
