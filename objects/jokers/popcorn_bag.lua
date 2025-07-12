SMODS.Joker({
	key = "popcorn_bag",
	atlas = "jokers",
	pos = {x = 3, y = 6},
    rarity = 1,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = true,
    config = {extra = {a_mult = 0, a_mult_add = 5, cap = 40}},
    artist_credits = {'gappie'},
	loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.a_mult, card.ability.extra.a_mult_add, card.ability.extra.cap}}
    end,
    calculate = function(self, card, context) --Popcorn Bag Logic
        if not context.blueprint and context.end_of_round and not context.individual and not context.repetition then
            if card.ability.extra.a_mult + card.ability.extra.a_mult_add > card.ability.extra.cap then
                SMODS.destroy_cards(card)
                return {
                    message = localize('ortalab_explode'),
                    colour = G.C.RED
                }
            else
                card.ability.extra.a_mult = card.ability.extra.a_mult + card.ability.extra.a_mult_add
                return {
                    card = card,
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.a_mult_add}}
                }
            end
        end
        if context.joker_main then
            if card.ability.extra.a_mult > 0 then
                return {
                    mult = card.ability.extra.a_mult
                }
            end
        end
    end
})
