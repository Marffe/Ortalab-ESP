SMODS.Joker({
	key = "miracle_cure",
	atlas = "jokers",
	pos = {x = 5, y = 3},
	rarity = 2,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {repetitions = 1}},
    artist_credits = {'gappie'},
    calculate = function(self, card, context)
        if context.before then
            for _, playing_card in pairs(context.scoring_hand) do
                if playing_card.debuff or playing_card.curse or playing_card.was_flipped then
                    playing_card.cured_debuff = playing_card.debuff
                    playing_card.debuff = false
                    playing_card.cured = true
                    playing_card.was_flipped = nil
                    G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function ()
                        playing_card.cured_debuff = false
                        card:juice_up()
                        return true
                    end}))
                    SMODS.calculate_effect({message = localize('ortalab_cured'), colour = G.C.PURPLE}, playing_card)
                end
            end
        end
        if context.repetition and context.cardarea == G.play and context.other_card.cured then
            context.other_card.cured = false
            return {
                repetitions = card.ability.extra.repetitions,
                message = localize('k_again_ex'),
                colour = G.C.PURPLE
            }
        end
    end
})

SMODS.DrawStep {
    key = 'miracle_cure',
    order = 1,
    func = function(self, layer)
        if self.cured_debuff then
            self.children.center:draw_shader('debuff', nil, self.ARGS.send_to_shader)
            if self.children.front and self.ability.effect ~= 'Stone Card' and not self.config.center.replace_base_card then
                self.children.front:draw_shader('debuff', nil, self.ARGS.send_to_shader)
            end
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}