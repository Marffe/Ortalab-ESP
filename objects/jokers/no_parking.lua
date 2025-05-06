SMODS.Joker({
    key = "no_parking",
    atlas = "jokers",
    pos = {x = 4, y = 5},
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {mult = 4}},
    artist_credits = {'kosze'},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            for _, _card in ipairs(G.hand.cards) do
                if _card:is_face() then
                    return
                end
            end
            return {
                mult = card.ability.extra.mult * #G.hand.cards
            }
        end
    end    
})