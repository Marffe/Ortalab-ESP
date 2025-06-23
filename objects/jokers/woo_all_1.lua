SMODS.Joker({
	key = "woo_all_1",
	atlas = "jokers",
	pos = {x = 8, y = 7},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	artist_credits = {'crimson'},
	config = {extra = {chance = 50}},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.chance}, key = card.ability.extra.disabled and 'j_ortalab_woo_all_1_disabled'}
	end,
	calculate = function(self, card, context)
		if context.setting_blind then
			if pseudoseed('ortalab_woo!') < card.ability.extra.chance/100 then
				card.ability.extra.disabled = true
				return {
					message = localize('k_disabled_ex'),
					colour = G.C.GREY
				}
			end
			card.ability.extra.disabled = nil
			return {
				message = localize('ortalab_enabled')
			}
		end
		if context.fix_probability and not card.ability.extra.disabled then
			return {
				numerator = context.denominator
			}
		end
	end
})

SMODS.DrawStep {
    key = 'woo_all_1',
    order = -1,
    func = function(self)
        if self.config.center_key == 'j_ortalab_woo_all_1' and self.ability.extra.disabled then
            self.children.center:draw_shader('ortalab_celadon', nil, self.ARGS.send_to_shader)
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}