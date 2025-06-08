SMODS.Joker({
	key = "pictographer",
	atlas = "jokers",
	pos = {x=3,y=10},
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {money = 25, count = 4, current = 0}},
    artist_credits = {'gappie'},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.money, card.ability.extra.count, card.ability.extra.current}}
	end,
	calculate = function(self, card, context)
        if context.using_consumeable and context.consumeable.ability.set == 'Loteria' and not context.blueprint then
            card.ability.extra.current = card.ability.extra.current + 1
            SMODS.calculate_effect({message = card.ability.extra.current..'/'..card.ability.extra.count, colour = G.ARGS.LOC_COLOURS.loteria}, card)
            if card.ability.extra.current == card.ability.extra.count then
                card.ability.extra.current = 0             
                return {
                    dollars = card.ability.extra.money,
                    message = localize('ortalab_joker_miles_reset'),
                    colour = G.ARGS.LOC_COLOURS.loteria
                }
            end
        end
        if context.end_of_round and context.main_eval and not context.blueprint then
            card.ability.extra.current = 0
            return {
                message = localize('ortalab_joker_miles_reset'),
                colour = G.ARGS.LOC_COLOURS.loteria
            }
        end
    end
})