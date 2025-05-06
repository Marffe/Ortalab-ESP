SMODS.Joker({
	key = "taliaferro",
	atlas = "jokers",
	pos = {x = 5, y = 2},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = true,
	no_pool_flag = 'taliaferro_extinct',
	config = {extra = {chips = 80, odds = 4}},
    artist_credits = {'flare','grassy'},
	loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips, math.max(G.GAME.probabilities.normal, 1), card.ability.extra.odds / math.min(G.GAME.probabilities.normal, 1)}}
    end,
    calculate = function(self, card, context) --Taliaferro Logic NOTE: MUST ADD POOL FLAGS
        if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            if pseudorandom('taliaferro') < G.GAME.probabilities.normal/card.ability.extra.odds then
                Ortalab.remove_joker(card)
                G.GAME.pool_flags.taliaferro_extinct = true
                return {
                    message = localize('k_extinct_ex')
                }
            else
                return {
                    message = localize('k_safe_ex')
                }
            end
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
})