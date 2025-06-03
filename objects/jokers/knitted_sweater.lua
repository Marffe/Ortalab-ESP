SMODS.Joker({
	key = "knitted_sweater",
	atlas = "jokers",
	pos = {x=2,y=11},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {chips = 0, chip_gain = 12}},
	artist_credits = {'gappie'},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.chip_gain, card.ability.extra.chips, localize('Three of a Kind', 'poker_hands')}}
	end,
	calculate = function(self, card, context)
        if context.before and next(context.poker_hands['Three of a Kind']) then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.BLUE,
            }
        end
        if context.joker_main and card.ability.extra.chips > 0 then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
})