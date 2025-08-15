SMODS.Challenge {
    key = 'police',
    stake = 'ortalab_one',
    rules = {
        modifiers = {
            SMODS.Stakes.stake_ortalab_one:modifiers()
        },
    },
    jokers = {
        {id = 'j_ortalab_policeman', eternal = true, edition = 'negative'},
    },
    vouchers = {
        {id = 'v_ortalab_shared_winnings'},
    },
    restrictions = {
        banned_cards = {
            {id = 'j_ortalab_cardist'},
            {id = 'j_ortalab_rockstar'},
            {id = 'v_ortalab_one_mans_trash'},
            {id = 'c_ortalab_lot_hand'},
            {id = 'c_ortalab_jackalope'},
        },
        banned_tags = {
            {id = 'tag_ortalab_hand'},
        },
        banned_other = {
            {id = 'bl_ortalab_fork', type = "blind"},
        }
    },
    deck = {
        type = 'Challenge Deck',
    unlocked = function(self)
		return true
	end,
    }
}



SMODS.Challenge {
    key = 'black_parade',
    rules = {
        modifiers = {},
    },
    jokers = {
        {id = 'j_ortalab_graffiti', eternal = true, edition = 'ortalab_anaglyphic'},
        {id = 'j_ortalab_grave_digger', eternal = true, edition = 'negative'},
    },
    vouchers = {
    },
    restrictions = {
        banned_cards = {
            {id = 'c_ortalab_lot_hand'},
        },
        banned_tags = {
            {id = 'tag_ortalab_hand'},
        },
        banned_other = {},
    },
    deck = {
        type = 'Challenge Deck',
    unlocked = function(self)
		return true
	end,
    }
}



SMODS.Challenge {
    key = 'copy_cat',
    rules = {
        modifiers = {},
    },
    jokers = {
        {id = 'j_ortalab_pinkprint', eternal = true, edition = 'ortalab_overexposed'},
        {id = 'j_ortalab_pinkprint', eternal = true, edition = 'ortalab_overexposed'},
    },
    vouchers = {
    },
    restrictions = {
        banned_cards = {
            {id = 'c_ortalab_lot_hand'},
        },
        banned_tags = {
            {id = 'tag_ortalab_hand'},
        },
        banned_other = {},
    },
    deck = {
        type = 'Challenge Deck',
    unlocked = function(self)
		return true
	end,
    }
}



SMODS.Challenge {
    key = 'cursed',
    rules = {
        modifiers = {},
    },
    jokers = {
        {id = 'j_ortalab_belmont', eternal = true},
        {id = 'j_ortalab_proletaire', eternal = true},
    },
    vouchers = {
        {id = 'v_ortalab_fates_coin'},
        {id = 'v_ortalab_arcane_archive'},
    },
    restrictions = {
        banned_cards = {
            {id = 'c_ortalab_lot_hand'},
        },
        banned_tags = {
            {id = 'tag_ortalab_hand'},
        },
        banned_other = {},
    },
    deck = {
        type = 'Challenge Deck',
    unlocked = function(self)
		return true
	end,
    }
}


SMODS.Challenge {
    key = 'stars',
    rules = {
        modifiers = {},
    },
    jokers = {
        {id = 'j_ortalab_astrologist', eternal = true},
        {id = 'j_ortalab_stargazing', eternal = true},
    },
    vouchers = {

    },
    restrictions = {
        banned_cards = {
            {id = 'c_ortalab_lot_hand'},
        },
        banned_tags = {
            {id = 'tag_ortalab_hand'},
        },
        banned_other = {},
    },
    deck = {
        type = 'Challenge Deck',
    unlocked = function(self)
		return true
	end,
    }
}




SMODS.Challenge {
    key = 'rusty_needle',
    rules = {
        modifiers = {
            {id = 'hand_size', value = 1},
            {id = 'discards', value = 5},
            --[[G.GAME.modifiers.stake_ortalab_one,]]
        },
    },
    jokers = {
        {id = 'j_ortalab_jester', edition = 'ortalab_anaglyphic'},
    },
    vouchers = {
        
    },
    restrictions = {
        banned_cards = {
            {id = 'j_ortalab_rockstar'},
            {id = 'j_ortalab_gloomy_gus'},
            {id = 'j_ortalab_klutz'},
            {id = 'j_ortalab_actor'},
            {id = 'v_ortalab_abacus'},
            {id = 'v_ortalab_recyclo_inv'},
        },
        banned_tags = {},
        banned_other = {
            {id = 'bl_ortalab_caramel_coin', type = "blind"},
            {id = 'bl_ortalab_sinker', type = "blind"},
            {id = 'bl_ortalab_saffron_shield', type = "blind"},
        }
    },
    deck = {
        type = 'Challenge Deck',
    unlocked = function(self)
		return true
	end,
    }
}


SMODS.Challenge {
    key = 'shinku_challenge',
    rules = {
        modifiers = {
        },
    },
    jokers = {
        {id = 'j_ortalab_shinku', eternal = true, edition = 'ortalab_overexposed'},
    },
    vouchers = {
        
    },
    restrictions = {
        banned_cards = {
        },
        banned_tags = {
        },
        banned_other = {}
    },
    deck = {
        type = 'Challenge Deck',
    unlocked = function(self)
		return true
	end,
    }
}


SMODS.Challenge {
    key = 'locked_in',
    rules = {
        modifiers = {
        },
    },
    jokers = {
        {id = 'j_ortalab_jester', eternal = true},
        {id = 'j_ortalab_jester', eternal = true},
        {id = 'j_ortalab_crime_scene', eternal = true},
        {id = 'j_ortalab_crime_scene', eternal = true},
        {id = 'j_ortalab_misfits', eternal = true},
    },
    vouchers = {
        
    },
    restrictions = {
        banned_cards = {
            {id = 'c_ortalab_lot_umbrella'},
            {id = 'c_ortalab_lot_melon'},
            {id = 'c_ortalab_lot_mandolin'},
            {id = 'c_ortalab_lot_rose'},
            {id = 'c_ortalab_lot_tree'},
            {id = 'c_ortalab_lot_siren'},
            {id = 'c_ortalab_lot_bird'},
            {id = 'c_ortalab_lot_rooster'},
            {id = 'c_ortalab_lot_pear'},
            {id = 'c_ortalab_lot_parrot'},
            {id = 'c_ortalab_lot_ladder'},
            {id = 'c_ortalab_lot_heron'},
            {id = 'c_ortalab_lot_heart'},
            {id = 'c_ortalab_lot_harp'},
            {id = 'c_ortalab_lot_flag'},
            {id = 'c_ortalab_lot_dandy'},
            {id = 'c_ortalab_lot_bottle'},
            {id = 'c_ortalab_lot_barrel'},
            {id = 'c_ortalab_lot_scorpion'},
            {id = 'c_ortalab_lot_bonnet'},
            {id = 'c_ortalab_lot_boot'},
        },
        banned_tags = {
            {id = 'tag_ortalab_soul'},
            {id = 'tag_ortalab_common'},
            {id = 'tag_ortalab_fluorescent'},
            {id = 'tag_ortalab_greyscale '},
            {id = 'tag_ortalab_overexposed'},
            {id = 'tag_ortalab_anaglyphic'},
        },
        banned_other = {}
    },
    deck = {
        type = 'Challenge Deck',
    unlocked = function(self)
		return true
	end,
    }
}



SMODS.Challenge {
    key = 'rich_kid',
    rules = {
        modifiers = {
        },
    },
    jokers = {
        {id = 'j_gift', eternal = true},
        {id = 'j_ortalab_priest', eternal = true},
    },
    vouchers = {
        {id = 'v_hone', eternal = true},
    },
    restrictions = {
        banned_cards = {
            {id = 'c_ortalab_lot_hand'},
        },
        banned_tags = {
            {id = 'tag_ortalab_hand'},
        },
        banned_other = {}
    },
    deck = {
        type = 'Challenge Deck',
    unlocked = function(self)
		return true
	end,
    }
}


SMODS.Challenge {
    key = 'evil_up',
    rules = {
        modifiers = {
            {id = 'hand_size', value = 4},
        },
    },
    jokers = {
        {id = 'j_ortalab_false_phd', eternal = true, edition = 'ortalab_overexposed'},
    },
    vouchers = {
        
    },
    restrictions = {
        banned_cards = {
            {id = 'j_ortalab_gloomy_gus'},
            {id = 'j_ortalab_klutz'},
            {id = 'j_ortalab_actor'},
            {id = 'j_turtle_bean'},
            {id = 'j_juggler'},
            {id = 'j_troubadour'},
            {id = 'j_merry_andy'},
            {id = 'c_ortalab_lot_hand'},
            {id = 'c_ortalab_jackalope'},
            {id = 'v_ortalab_abacus'},
            {id = 'v_paint_brush'},
        },
        banned_tags = {
            {id = 'tag_ortalab_hand'},
        },
        banned_other = {}
    },
    deck = {
        type = 'Challenge Deck',
    unlocked = function(self)
		return true
	end,
    }
}


SMODS.Challenge {
    key = 'idk',
    rules = {
        modifiers = {
        },
    },
    jokers = {
        {id = 'j_ortalab_freezer', eternal = true},
        {id = 'j_ortalab_head_honcho', eternal = true},
        {id = 'c_medium', eternal = true},
    },
    vouchers = {
        {id = 'v_crystal_ball', eternal = true},
    },
    restrictions = {
        banned_cards = {
            {id = 'c_ortalab_lot_hand'},
        },
        banned_tags = {
            {id = 'tag_ortalab_hand'},
        },
        banned_other = {
            --[[{id = 'bl_water', type = "blind"}]]
        }
    },
    deck = {
        type = 'Challenge Deck',
    unlocked = function(self)
		return true
	end,
    }
}


SMODS.Challenge {
    key = 'fingers',
    rules = {
        modifiers = {
        },
    },
    jokers = {
    },
    vouchers = {
        
    },
    restrictions = {
        banned_cards = {
            {id = 'j_ortalab_sandstone'},
            {id = 'j_ortalab_false_phd'},
            {id = 'c_ortalab_lot_umbrella'},
            {id = 'c_ortalab_lot_melon'},
            {id = 'c_ortalab_lot_mandolin'},
            {id = 'c_ortalab_lot_rose'},
            {id = 'c_ortalab_lot_siren'},
            {id = 'c_ortalab_lot_bird'},
            {id = 'c_ortalab_lot_ladder'},
            {id = 'c_ortalab_lot_dandy'},
            {id = 'c_ortalab_zod_taurus'},
            {id = 'c_ortalab_zod_scorpio'},
            {id = 'c_ortalab_excalibur'},
            {id = 'c_ortalab_kraken'},
            {id = 'c_ortalab_basilisk'},
            {id = 'c_ortalab_abaia'},
            {id = 'c_ortalab_jormungand'},

            --[[{id = 'p_buffoon_normal_1', ids = {
                'p_buffoon_normal_1','p_buffoon_normal_2','p_buffoon_jumbo_1','p_buffoon_mega_1',
            }},]]
        },
        banned_tags = {
            {id = 'tag_ortalab_hand'},
        },
        banned_other = {
            {id = 'bl_ortalab_hammer', type = "blind"},
        }
    },
    deck = {
        type = 'Challenge Deck',
    unlocked = function(self)
		return true
	end,
    cards = {
            {s='D',r='2',e='m_ortalab_sand',},
            {s='D',r='3',e='m_ortalab_sand',},
            {s='D',r='4',e='m_ortalab_sand',},
            {s='D',r='5',e='m_ortalab_sand',},
            {s='D',r='6',e='m_ortalab_sand',},
            {s='D',r='7',e='m_ortalab_sand',},
            {s='D',r='8',e='m_ortalab_sand',},
            {s='D',r='9',e='m_ortalab_sand',},
            {s='D',r='T',e='m_ortalab_sand',},
            {s='D',r='J',e='m_ortalab_sand',},
            {s='D',r='Q',e='m_ortalab_sand',},
            {s='D',r='K',e='m_ortalab_sand',},
            {s='D',r='A',e='m_ortalab_sand',},
            {s='C',r='2',e='m_ortalab_sand',},
            {s='C',r='3',e='m_ortalab_sand',},
            {s='C',r='4',e='m_ortalab_sand',},
            {s='C',r='5',e='m_ortalab_sand',},
            {s='C',r='6',e='m_ortalab_sand',},
            {s='C',r='7',e='m_ortalab_sand',},
            {s='C',r='8',e='m_ortalab_sand',},
            {s='C',r='9',e='m_ortalab_sand',},
            {s='C',r='T',e='m_ortalab_sand',},
            {s='C',r='J',e='m_ortalab_sand',},
            {s='C',r='Q',e='m_ortalab_sand',},
            {s='C',r='K',e='m_ortalab_sand',},
            {s='C',r='A',e='m_ortalab_sand',},
            {s='H',r='2',e='m_ortalab_sand',},
            {s='H',r='3',e='m_ortalab_sand',},
            {s='H',r='4',e='m_ortalab_sand',},
            {s='H',r='5',e='m_ortalab_sand',},
            {s='H',r='6',e='m_ortalab_sand',},
            {s='H',r='7',e='m_ortalab_sand',},
            {s='H',r='8',e='m_ortalab_sand',},
            {s='H',r='9',e='m_ortalab_sand',},
            {s='H',r='T',e='m_ortalab_sand',},
            {s='H',r='J',e='m_ortalab_sand',},
            {s='H',r='Q',e='m_ortalab_sand',},
            {s='H',r='K',e='m_ortalab_sand',},
            {s='H',r='A',e='m_ortalab_sand',},
            {s='S',r='2',e='m_ortalab_sand',},
            {s='S',r='3',e='m_ortalab_sand',},
            {s='S',r='4',e='m_ortalab_sand',},
            {s='S',r='5',e='m_ortalab_sand',},
            {s='S',r='6',e='m_ortalab_sand',},
            {s='S',r='7',e='m_ortalab_sand',},
            {s='S',r='8',e='m_ortalab_sand',},
            {s='S',r='9',e='m_ortalab_sand',},
            {s='S',r='T',e='m_ortalab_sand',},
            {s='S',r='J',e='m_ortalab_sand',},
            {s='S',r='Q',e='m_ortalab_sand',},
            {s='S',r='K',e='m_ortalab_sand',},
            {s='S',r='A',e='m_ortalab_sand',},
        }
    }
}
