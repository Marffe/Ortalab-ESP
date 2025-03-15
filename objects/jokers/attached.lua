SMODS.Joker({
    key = "attached",
    atlas = "jokers",
    pos = {x = 7, y = 8},
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {xmult = 1.5, sticker = 'eternal'}},
    loc_vars = function(self, info_queue, card)
        if card and not card.fake_card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'no_demo'} end
        return {vars = {card.ability.extra.xmult, localize({type = 'name_text', set = 'Other', key = card.ability.extra.sticker})}}
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            local to_eternal = G.jokers.cards[#G.jokers.cards]
            if not to_eternal.ability[card.ability.extra.sticker] and to_eternal ~= card then
                
                return {
                    message = 'Attached!',
                    message_card = to_eternal,
                    func = function()
                        card:juice_up()
                        to_eternal:add_sticker(card.ability.extra.sticker, true)
                        if to_eternal.ability.perishable then to_eternal.ability.perishable = false end
                    end
                }
            end
        end
        if context.other_joker and context.other_joker.ability.eternal then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end    
})