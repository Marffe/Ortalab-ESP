SMODS.Joker({
	key = "croupier",
	atlas = "jokers",
	pos = {x = 1, y = 4},
	rarity = 2,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {bonus_slots = 1}},
	loc_vars = function(self, info_queue, card)
        if card and not card.fake_card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
		return {vars = {card.ability.extra.bonus_slots}}
    end,
	add_to_deck = function(self, card, from_debuff)
		change_shop_size(card.ability.extra.bonus_slots)
	end,
	remove_from_deck = function(self, card, from_debuff)
		change_shop_size(-card.ability.extra.bonus_slots)
	end
})