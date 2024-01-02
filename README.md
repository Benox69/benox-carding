# Project Name

## Installation

1. Add SQL to your database.
2. Add the following code to `ox_inventory\data\items.lua`:

```lua
[
    'msr90'] = {
        label = 'MSR90',
        weight = 220,
        stack = false,
        consume = 0,
    },
    ['blank_card'] = {
        label = 'Blank Card',
        weight = 220,
        stack = false,
        client = {
            export = 'benox-carding.benox:useCard',
        },
        consume = 0,
    }
]
