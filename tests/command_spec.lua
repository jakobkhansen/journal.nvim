local command = require("journal.command")
describe(':Journal', function()
    it(':Journal', function()
        assert(command.execute({}))
    end)
    it(':Journal aslkdj', function()
        assert(command.execute({ 'asldkj' }) == false, "Invalid type and date")
    end)
end)
