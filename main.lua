Ortalab = SMODS.current_mod
Ortalab.load_table = {
    jokers = true,
    enhancements = true,
    editions = true,
    loteria = true,
    zodiac = true,
    patches = true,
    decks = true,
    coupons = true,
    stakes = true,
    blinds = true,
    curses = true,
    mythos = true
}
loc_colour('red')
G.ARGS.LOC_COLOURS['Ortalab'] = HEX('990000')
G.ARGS.LOC_COLOURS.Ort_menu_colourA = HEX('686868')
G.ARGS.LOC_COLOURS.Ort_menu_colourB = HEX('C9013C')
for k, v in pairs(Ortalab.load_table) do
    if v then assert(SMODS.load_file('objects/'..k..'.lua'))() end
end

assert(SMODS.load_file('util/artists.lua'))()
assert(SMODS.load_file('util/functions.lua'))()
assert(SMODS.load_file('util/menu.lua'))()

SMODS.Atlas({
    key = 'modicon',
    path = 'modicon.png',
    px = '34',
    py = '34'
})

Ortalab.optional_features = function()
    return {
        retrigger_joker = true,
    }
end


if (SMODS.Mods['malverk'] or {}).can_load then
    AltTextures_Utils.default_atlas['Zodiac'] = 'ortalab_zodiac_cards'
    AltTextures_Utils.loc_keys['Zodiac'] = 'b_zodiac_cards'
    AltTexture({
        key = 'alt_zodiac',
        set = 'Zodiac',
        path = 'zodiac_coloured.png',
        display_pos = 'c_ortalab_zod_virgo',
        loc_txt = {
            name = 'Rainbow Zodiac'
        }
    })

    TexturePack{
        key = 'alt_orta',
        textures = {
            'ortalab_alt_zodiac',
        },
        loc_txt = {
            name = 'Full Colour Zodiacs',
            text = {
                'Alternate art for {C:zodiac}Zodiac',
            }
        }
    }
end