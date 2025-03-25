SMODS.Joker({
    key = "wide",
    atlas = "jokers",
    pos = {x = 8, y = 14},
    rarity = 3,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    config = {extra = {mult = 4, gain = 2}},
    -- display_size = {w = 142, h = 50},
    loc_vars = function(self, info_queue, card)
        if card and not card.fake_card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        return {vars = {card.ability.extra.gain, card.ability.extra.mult}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 10 then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain
                return {
                    message = localize('k_upgrade_ex'),
                    message_card = card,
                    colour = G.C.RED
                }
            end
        end
    end    
})

local hover = Card.hover
function Card:hover()
    hover(self)
    if self.config.center_key == 'j_ortalab_wide' and self.T.w == G.CARD_W then
        ease_value(self.T, 'w', self.T.w, nil, nil, nil, nil, 'elastic')
        ease_value(self.T, 'h', -(self.T.h/2), nil, nil, nil, nil, 'elastic')
    end
end

local stop_hover = Card.stop_hover
function Card:stop_hover()
    stop_hover(self)
    if self.config.center_key == 'j_ortalab_wide' and self.T.w > G.CARD_W then
        ease_value(self.T, 'w', G.CARD_W - self.T.w)
        ease_value(self.T, 'h', G.CARD_H - self.T.h)
    end
end