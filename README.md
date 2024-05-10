# 🖋️ journal.nvim

journal.nvim is a simple yet powerful journaling system for Neovim.

## ✨ Features

- Create daily, weekly, monthly or yearly journal entries with sane defaults
- Extend your journal with custom entry types, allowing grouping, multiple journals and more
- Define custom templates for each entry type. Custom templates can contain date
  information such as the current weekday or month
- Flexible filesystem. Flat or deeply-nested, group entries based on month or even hour of the day.
- Everything exposed under a `:Journal` command, with auto-completion for all your entry types
- Linux, MacOS and Windows[\*](#windows-support) support

TODO: Video demonstration here

## 📦 Installation

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

## ⚙️ Configuration

You can configure journal.nvim by passing a table to the setup function. The following
table are the options and default values:

```lua
{
    filetype = 'md',                    -- Filetype to use for new journal entries
    root = '~/journal',                 -- String or () => String. Root directory for journal entries
    date_format = '%d/%m/%Y',           -- Date format for `:Journal <date-modifier>`
    autocomplete_date_modifier = "end", -- "always"|"never"|"end". Enable date modifier autocompletion

    -- Configuration for journal entries
    journal = {
        -- Default configuration for `:Journal <date-modifier>`
        format = '%Y/%m-%B/daily/%d-%A',
        template = '# %A %B %d %Y custom\n',
        frequency = { day = 1 },

        -- Nested configurations for `:Journal <type> <type> ... <date-modifier>`
        entries = {
            day = {
                format = '%Y/%m-%B/daily/%d-%A', -- Format of the journal entry in the filesystem. See `:help strftime` for options
                template = '# %A %B %d %Y\n',    -- Template used when creating a new journal entry
                frequency = { day = 1 },         -- The frequency of the journal entry. Used for `:Journal next`, `:Journal -2` etc
            },
            week = {
                format = '%Y/%m-%B/weekly/week',
                template = "# Week %W %B %Y\n",
                frequency = { day = 7 },
                default_date_modifier = "monday" -- Default date modifier, makes `:Journal week` = `:Journal week monday`
            },
            month = {
                format = '%Y/%m-%B/%B',
                template = "# %B %Y\n",
                frequency = { month = 1 }
            },
            year = {
                format = '%Y/%Y',
                template = "# %Y\n",
                frequency = { year = 1 }
            },
        },
    }
}
```

### Custom and nested entry types

## 🖋️ The `:Journal` command

`:Journal <type> <type> ... <date-modifier>` can be used to access all your journal
entries. `:Journal` takes the following arguments:

- `<type>`: An entry type (e.g. `day`, `week` etc) to determine which entry-type to open. Can be nested.
- `<date-modifier>`. A date-modifier to determine which date the entry is for. If no date

### Date-modifiers

The `:Journal` command can take a plethora of different date-modifiers to determine which
entry should be opened:

- Weekdays (e.g. `monday`, `tuesday`...): The date for the current weeks instance
  of the given weekday
- Date-string (e.g. `10/05/2024`): Parses the date-string to a date according to the `date_format` option
- `+n`/`-n` (e.g. `-1`, `+5`, ...): The date relative to today. Computes the relative
  date with `n*frequency`, meaning `:Journal week -1` will go one week back, while `:Journal day +1`
  will one day forward.
- `last`/`next`: Same as `-1`/`+1`
- `n` (e.g. `1`, `18`, ...): Gets the date for the nth day of the current month.

## 🪟 Windows support

journal.nvim will work great for most users on Windows. However, due to the missing
implementation of `vim.fn.strptime`, accessing a journal entry via the datestring
date-modifier will not always work great. journal.nvim tries to translate the
`date_format` option into a format which `Get-Date` in Windows can understand (but this is
not a 1:1 mapping). This allows most sane date-formats to be used as datestrings, but
expect to see issues if you use a complex `date_format` option on Windows.
