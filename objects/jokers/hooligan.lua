SMODS.Joker({
    key = "hooligan",
    atlas = "jokers",
    pos = {x = 1, y = 14},
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {blind_size = 2, vouchers = 1}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'no_demo'} end
        return {vars = {card.ability.extra.blind_size}}
    end,
    add_to_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({func = function()
            update_blind_amounts()
            return true
        end}))
    end,
    remove_from_deck = function(self, card, from_debuff)
        update_blind_amounts()
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and G.GAME.blind.boss then
            local _pool = get_current_pool('Voucher')
        local voucher = pseudorandom_element(_pool, pseudoseed('ortalab_hooligan'))
        local it = 1
        while voucher == 'UNAVAILABLE' do
            it = it + 1
            voucher = pseudorandom_element(_pool, pseudoseed('ortalab_hooligan'..it))
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.5,
            func = function()
                local juice_hooligan = true
                local eval = function() return juice_hooligan end
                juice_card_until(card, eval, true)
                local voucher_card = SMODS.create_card({area = G.play, key = voucher})
                voucher_card:start_materialize()
                voucher_card.cost = 0
                G.play:emplace(voucher_card)
                delay(0.8)
                voucher_card:redeem()
                
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.5,
                    func = function()
                        voucher_card:start_dissolve()                
                        juice_hooligan = false
                        return true
                    end
                }))
                return true
            end
        }))
        end
    end    
})

local get_blind_amount_ref = get_blind_amount
function get_blind_amount(ante)
    local amount = get_blind_amount_ref(ante)
    local hooligans = SMODS.find_card('j_ortalab_hooligan')
    for _, card in ipairs(hooligans) do
        amount = amount * card.ability.extra.blind_size
    end
    return amount
end