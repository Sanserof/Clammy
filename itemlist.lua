--[[
    itemlist.lua - Full clamming item data for Clammy addon
    Contains: item name, weight, NPC gil, AH gil, sell strategy

    Last updated: February 03, 2026
    Update ah_gil values here when HorizonXI market prices change significantly.

    Note: for items which such low market traffic they're not worth putting on AH, I've put ah_gil=0
--]]

local itemlist = {}

itemlist.clammingItems = {
    { item = "Bibiki slug",               weight = 3,  npc_gil = 10,    ah_gil = 0,     sell_to = "NPC"   },
    { item = "Bibiki urchin",             weight = 6,  npc_gil = 750,   ah_gil = 0,     sell_to = "NPC"   },
    { item = "Broken willow fishing rod", weight = 6,  npc_gil = 0,     ah_gil = 0,     sell_to = "Trash" },
    { item = "Coral fragment",            weight = 6,  npc_gil = 1735,  ah_gil = 4000,  sell_to = "AH"    },
    { item = "Quality crab shell",        weight = 6,  npc_gil = 3312,  ah_gil = 4000,  sell_to = "AH"    },
    { item = "Crab shell",                weight = 6,  npc_gil = 392,   ah_gil = 300,   sell_to = "NPC"   },
    { item = "Elm log",                   weight = 6,  npc_gil = 390,   ah_gil = 4000,  sell_to = "AH"    },
    { item = "Fish scales",               weight = 3,  npc_gil = 23,    ah_gil = 200,   sell_to = "NPC"   },
    { item = "Goblin armor",              weight = 6,  npc_gil = 0,     ah_gil = 0,     sell_to = "Trash" },
    { item = "Goblin mail",               weight = 6,  npc_gil = 0,     ah_gil = 1000,  sell_to = "AH"    },
    { item = "Goblin mask",               weight = 6,  npc_gil = 0,     ah_gil = 300,   sell_to = "AH"    },
    { item = "Hobgoblin bread",           weight = 6,  npc_gil = 91,    ah_gil = 0,     sell_to = "NPC"   },
    { item = "Hobgoblin pie",             weight = 6,  npc_gil = 153,   ah_gil = 0,     sell_to = "NPC"   },
    { item = "Jacknife",                  weight = 11, npc_gil = 56,    ah_gil = 0,     sell_to = "NPC"   },
    { item = "Lacquer tree log",          weight = 6,  npc_gil = 3578,  ah_gil = 6000,  sell_to = "AH"    },
    { item = "Maple log",                 weight = 6,  npc_gil = 15,    ah_gil = 300,   sell_to = "AH"    },
    { item = "Nebimonite",                weight = 6,  npc_gil = 53,    ah_gil = 200,   sell_to = "NPC"   },
    { item = "Oxblood",                   weight = 6,  npc_gil = 13250, ah_gil = 13000, sell_to = "NPC"   },
    { item = "Pamtam kelp",               weight = 6,  npc_gil = 7,     ah_gil = 300,   sell_to = "NPC"   },
    { item = "Pebble",                    weight = 7,  npc_gil = 1,     ah_gil = 0,     sell_to = "NPC"   },
    { item = "Petrified log",             weight = 6,  npc_gil = 2193,  ah_gil = 3300,  sell_to = "AH"    },
    { item = "Quality pugil scales",      weight = 6,  npc_gil = 253,   ah_gil = 0,     sell_to = "NPC"   },
    { item = "Pugil scales",              weight = 3,  npc_gil = 23,    ah_gil = 0,     sell_to = "NPC"   },
    { item = "Seashell",                  weight = 6,  npc_gil = 29,    ah_gil = 0,     sell_to = "NPC"   },
    { item = "Shall shell",               weight = 6,  npc_gil = 307,   ah_gil = 400,   sell_to = "NPC"   },
    { item = "Titanictus shell",          weight = 6,  npc_gil = 357,   ah_gil = 1000,  sell_to = "AH"    },
    { item = "Tropical clam",             weight = 20, npc_gil = 5100,  ah_gil = 6000,  sell_to = "AH"    },
    { item = "Turtle shell",              weight = 6,  npc_gil = 1190,  ah_gil = 1300,  sell_to = "NPC"   },
    { item = "Uragnite shell",            weight = 6,  npc_gil = 1455,  ah_gil = 2000,  sell_to = "AH"    },
    { item = "Vongola clam",              weight = 6,  npc_gil = 192,   ah_gil = 0,     sell_to = "NPC"   },
    { item = "White sand",                weight = 7,  npc_gil = 250,   ah_gil = 0,     sell_to = "NPC"   },
}

return itemlist
