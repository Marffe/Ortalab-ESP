SMODS.Joker({
	key = "scam_email",
	atlas = "jokers",
	pos = {x=5,y=5},
	rarity = 1,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {dollars = 3, rank = 'Jack'}},
    artist_credits = {'gappie'},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.dollars, localize(card.ability.extra.rank, 'ranks')}}
	end,
    set_ability = function(self, card)
        if G.playing_cards and #G.playing_cards > 0 then
            card.ability.extra.rank = Ortalab.rank_from_deck('ortalab_scam_email')
        end
    end,
	calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context.blueprint then
            card.ability.extra.rank = Ortalab.rank_from_deck('ortalab_scam_email')
            return {
                message = localize(card.ability.extra.rank, 'ranks'),
                no_retrigger = true
            }
        end
		if context.cardarea == G.play and context.individual and context.other_card.base.value == card.ability.extra.rank then
            return {
                dollars = card.ability.extra.dollars
            }
        end
        
    end
})