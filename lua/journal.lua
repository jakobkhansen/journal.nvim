local public = require("journal.public")

public.setup = function(opts)
    require('journal.config').setup(opts)
    require('journal.setup').setup()
end

return public
