local public = require("journal.public")

public.setup = function(opts)
    require('journal.config').setup(opts)
    require('journal.command').setup()
end

return public
