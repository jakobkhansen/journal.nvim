# journal.nvim

journal.nvim is a simple yet powerful journaling system for Neovim.

## Features

- Create daily, weekly, monthly or yearly journal entries with sane defaults
- Extend your journal with custom entry types, allowing grouping, multiple journals and more
- Define custom templates for each entry type. Custom templates can contain variable date
  information such as the current weekday or month
- Flexible filesystem. Flat, deeply-nested, group based on month or even hour of the day? All possible
- Everything exposed under a `:Journal` command, with auto-completion for your custom journal entry types

TODO: Video demonstration here

## Installation

journal.nvim can be installed just like you install any other Neovim plugin.

### Lazy.nvim

```lua
{
    "jakobkhansen/journal.nvim",
    config = function()
        require("journal").setup()
    end,
},
```

TODO: Add Packer at least

## Configuration

You can configure journal.nvim by passing a table to the setup function. The following
table are the options and default values:

```lua
{
    filetype = 'md',                    -- Filetype to use for new journal entries
    root = '~/journal',                 -- String or () => String. Root directory for journal entries
    date_format = '%d/%m/%Y',           -- Date format for `:Journal <date-modifier>`. See `man strftime` for options
    autocomplete_date_modifier = "end", -- "always"|"never"|"end". Enable date modifier autocompletion

    -- Configuration for journal entries
    journal = {
        -- Default configuration for `:Journal <date-modifier>`
        format = '%Y/%m-%B/daily/%d-%A',
        template = '# %A %B %d %Y custom\n',
        frequency = { day = 1, month = 0, year = 0 },

        -- Nested configurations for `:Journal <type> <type> ... <date-modifier>`
        entries = {
            day = {
                format = '%Y/%m-%B/daily/%d-%A',              -- Format of the journal entry in the filesystem. See `man strftime` for options
                template = '# %A %B %d %Y\n',                 -- Template used when creating a new journal entry
                frequency = { day = 1, month = 0, year = 0 }, -- The frequency of the journal entry. Used for `:Journal next`, `:Journal -2` etc
            },
            week = {
                format = '%Y/%m-%B/weekly/week-%W',
                template = "# Week %W %B %Y\n",
                frequency = { day = 7, month = 0, year = 0 }
            },
            month = {
                format = '%Y/%m-%B/%B',
                template = "# %B %Y\n",
                frequency = { day = 0, month = 1, year = 0 }
            },
            year = {
                format = '%Y/%Y',
                template = "# %Y\n",
                frequency = { day = 0, month = 0, year = 1 }
            },
        },
    }
}
```
