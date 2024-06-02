# 🖋️ journal.nvim

**journal.nvim** is a highly extensible journaling system for Neovim.

## ✨ Features

- Create daily, weekly, monthly or yearly journal entries with sane defaults
- Extend your journal with custom entry types, allowing grouping, multiple journals and more
- Define custom templates for each entry type. Custom templates can contain date
  information such as the current weekday or month
- Flexible filesystem. flat or deeply-nested, group entries based on month or even hour of the day
- Everything exposed under a `:Journal` command, with auto-completion for all your entry types
- Linux, MacOS and Windows[\*](#-windows-support) support
- A [cookbook](#cookbook) of useful configurations from the community

![journalnvim](https://github.com/jakobkhansen/journal.nvim/assets/8071566/3a52d405-aa33-4aa8-8345-3b8709aa21f7)

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

### Packer.nvim

```lua
use {
    'jakobkhansen/journal.nvim',
    config = function()
        require('journal').setup()
    end
}

```

## ⚙️ Configuration

You can configure journal.nvim by passing a table to the setup function. The following
table are the options and default values:

```lua
{
    filetype = 'md',                    -- Filetype to use for new journal entries
    root = '~/journal',                 -- Root directory for journal entries
    date_format = '%d/%m/%Y',           -- Date format for `:Journal <date-modifier>`
    autocomplete_date_modifier = "end", -- "always"|"never"|"end". Enable date modifier autocompletion

    -- Configuration for journal entries
    journal = {
        -- Default configuration for `:Journal <date-modifier>`
        format = '%Y/%m-%B/daily/%d-%A',
        template = '# %A %B %d %Y\n',
        frequency = { day = 1 },

        -- Nested configurations for `:Journal <type> <type> ... <date-modifier>`
        entries = {
            day = {
                format = '%Y/%m-%B/daily/%d-%A', -- Format of the journal entry in the filesystem.
                template = '# %A %B %d %Y\n',    -- Optional. Template used when creating a new journal entry
                frequency = { day = 1 },         -- Optional. The frequency of the journal entry. Used for `:Journal next`, `:Journal -2` etc
            },
            week = {
                format = '%Y/%m-%B/weekly/week-%W',
                template = "# Week %W %B %Y\n",
                frequency = { day = 7 },
                date_modifier = "monday" -- Optional. Date modifier applied before other modifier given to `:Journal`
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

All string values can be replaced by functions that return strings. `format` and
`template` options also get a [`Date`](lua/journal/date.lua) argument.

All `format` and `template` options are parsed with `vim.fn.strftime`. To see the available variables, see
`:h strftime` and `man strftime`. Note that `strftime` can have different behavior based on platform.

## 🖋️ The `:Journal` command

`:Journal <type> <type> ... <date-modifier>` can be used to access all your journal
entries. `:Journal` takes the following arguments:

- `<type>`: An entry type (e.g. `day`, `week` etc) to determine which entry type to open. Can be nested
- `<date-modifier>`. A date-modifier to determine which date the entry is for. If no date
  is provided, defaults to today. If `date_modifier` is specified for the given entry type,
  it is applied before the `<date-modifier>` argument is applied

### Date-modifiers

The `:Journal` command can take a plethora of different date-modifiers to determine which
entry should be opened:

- Weekdays (e.g. `monday`, `tuesday`...): The date for the current weeks instance
  of the given weekday
- Date-string (e.g. `10/05/2024`): Parses the date-string to a date according to the `date_format` option
- `+n`/`-n` (e.g. `-1`, `+5`, ...): Relative date. Computes the relative
  date with `n*frequency`, meaning `:Journal week -1` will go one week back, while `:Journal day +1`
  will go one day forward
- `last`/`next`: Same as `-1`/`+1`
- `n` (e.g. `1`, `18`, ...): Gets the date for the nth day of the month

## 📚 Entries

Each entry type in the `entries` table correspond to a `:Journal <type>` command. Running
`:Journal <type>` will create a journal entry file with a path given by the `format`
option and fills the file with the `template` option. For example `:Journal week` could
create an entry with the path `2024/05-May/weekly/week-19`, pre-filled with the template
`# Week 19 May 2024`.

### Custom entry types

You can also define custom entry types in your journal by simply adding more entry types to the
`entries` table. A `quarter` entry type could be configured like so:

```lua
{
    journal = {
        entries = {
            -- Entry type for each quarter of the year
            quarter = {
                -- strftime doesn't supply a quarter variable, so we compute it manually
                format = function(date)
                    local quarter = math.ceil(tonumber(os.date("%m", os.time(date.date))) / 3)
                    return "%Y/quarter/" .. quarter
                end,
                template = function(date)
                    local quarter = math.ceil(os.date("%m", os.time(date.date)) / 3)
                    return "# %Y Quarter " .. quarter .. "\n"
                end,
                frequency = { month = 3 },
            }
        }
    }
}
```

This entry type will generate entry paths such as `2024/quarter/2.md`.

### Nested entry types

You can also define nested entry types in your journal in order to group different entry
types by adding an `entries` table to any of your entry types. This allows you to run
commands such as `:Journal groupA week` and `:Journal groupB week`. Journal entries can be
arbitrarily nested to support as much grouping as you want. The following table shows how
you can create two groups with individual `day` and `week` entry types in separate folders.

```lua
{
    journal = {
        entries = {
            groupA = {
                -- `:Journal groupA`
                format = 'groupA/%Y/%m-%B/daily/%d-%A',
                template = "# Group A %A %B %d %Y\n",
                frequency = { day = 1 },

                entries = {
                    -- `:Journal groupA day`
                    day = {
                        format = 'groupA/%Y/%m-%B/daily/%d-%A',
                        template = "# Group A %A %B %d %Y\n",
                        frequency = { day = 1 },
                    },
                    -- `:Journal groupA week`
                    week = {
                        format = 'groupA/%Y/%m-%B/weekly/week-%W',
                        template = "# Group A Week %W %B %Y\n",
                        frequency = { day = 7 },
                        date_modifier = "monday"
                    },
                }
            },
            groupB = {
                -- `:Journal groupB`
                format = 'groupB/%Y/%m-%B/daily/%d-%A',
                template = "# Group B %A %B %d %Y\n",
                frequency = { day = 1 },

                entries = {
                    -- `:Journal groupB day`
                    day = {
                        format = 'groupB/%Y/%m-%B/daily/%d-%A',
                        template = "# Group B %A %B %d %Y\n",
                        frequency = { day = 1 },
                    },
                    -- `:Journal groupB week`
                    week = {
                        format = 'groupB/%Y/%m-%B/weekly/week-%W',
                        template = "# Group B Week %W %B %Y\n",
                        frequency = { day = 7 },
                        date_modifier = "monday"
                    },
                }
            },
        }
    }
}
```

### Templates

journal.nvim allows you to specify templates for all of your entry types, which will be
applied to any new entry file that is created. Your templates can contain date variables
just like the `format` options (these are parsed with `vim.fn.strftime`). Additionally,
just like formats, you can set a template to a function which returns a string and
programatically build your template string. This could be used to for example take user
input to set a title, or return completely different templates based on user choice (See
`vim.ui.select`). The following example shows how you can set a dynamic title with
`vim.ui.input`. Note that date variables in templates being passed to `string.format`
needs to have `%%` instead of `%` as a prefix in order to be ignored by `string.format`.

```lua
template = function()
    local title = nil
    vim.ui.input({ prompt = 'Title: ' }, function(input) title = input end)
    return string.format("# %%Y %%B %%d: %s", title)
end
```

Based on user input, this template could produce headers such as `# 2024 May 12: Custom title`

### Multiple journals

While grouping probably covers most users need for grouping different entries, it is also
possible to have completely separate journal directories. One could achieve this by
setting the `root` option to a common folder such as `~` and then specify the folders in
the `format` of each entry type.

Another option is to set the `root` field to a function which returns the root directory
of the journal. This function could return different directories based on cwd (`uv.cwd()`)
or user input. The following function could be used to show a list of directories and let
the user pick one:

```lua
{
    root = function()
        local journal_dir = nil
        vim.ui.select(
            { "~/journal1", "~/journal2" },
            { prompt = "Select journal directory" },
            function(selection) journal_dir = selection end
        )
        return journal_dir
    end,
}
```

## 🪟 Windows support

journal.nvim will work great for most users on Windows. However, due to the missing
implementation of `vim.fn.strptime`, accessing a journal entry via the date-string
date-modifier will not always work great. journal.nvim tries to translate the
`date_format` option into a format which `Get-Date` in Windows can understand (but this is
not a 1:1 mapping). This allows most sane date-formats to be used as datestrings, but
expect to see issues if you use a complex `date_format` option on Windows.

## Cookbook

The following section is a collection of configurations which the community have deemed to
be useful. PRs for more examples in the cookbook are welcome!

<details>
<summary>Date range in week template</summary>

The following configuration will generate the date range for the week entry type. This
configuration generates headers such as:

<code># Week 22 - Monday 27/05 -> Sunday 02/06</code>.

```lua
week = {
    format = '%Y/%m-%B/weekly/week-%W',
    template = function(date)
        local sunday = date:relative({ day = 6 })
        local end_date = os.date('%A %d/%m', os.time(sunday.date))
        return "# Week %W - %A %d/%m -> " .. end_date .. "\n"
    end,
    frequency = { day = 7 },
    date_modifier = "monday"
}
```

</details>

<details>
<summary>Jekyll blog entry generator</summary>

This configuration will generate blog posts for your Jekyll blog.

```lua
local template =
[[
---
layout: post
title: "%Y %B %d"
categories: Blog
---
]]

require("journal").setup({
    root = '~/Documents/blog/_posts', -- Replace with your blog path
    journal = {
        format = '%Y/%m/%Y-%m-%d-post',
        frequency = { day = 1 },
        template = template
    }
})
```

If you want something more dynamic such as dynamic titles for your posts, you can use
<code>vim.ui.input</code> in your template function:

```lua
template = function()
    local title = nil
    vim.ui.input({ prompt = 'Title: ' }, function(input) title = input end)
    return string.format(template, title)
end
```

and change the template to:

```lua
local template = [[
---
layout: post
title: "%s"
categories: Blog
---
]]
```

</details>

<details>
<summary>Integrating with existing Neorg journal</summary>

Some users might already be using Neorg journal and want to integrate with an existing
journal there. The following configuration will simulate the default Neorg journal with
the <code>strategy = nested</code> option.

```lua
require("journal").setup({
    filetype = 'md',
    journal = {
        format = '%Y/%m/%d',
    }
})
```

</details>
