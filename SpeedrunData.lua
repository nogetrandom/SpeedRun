Speedrun = Speedrun or { }
local Speedrun = Speedrun

-------------------
---- Raid List ----
-------------------
Speedrun.raidList = {
    [638] = {
        name = "AA",
        id = 638,
        timerSteps = {},
    },
    [636] = {
        name = "HRC",
        id = 636,
        timerSteps = {},
    },
    [639] = {
        name = "SO",
        id = 639,
        timerSteps = {},
    },
    [725] = {
        name = "MoL",
        id = 725,
        timerSteps = {},
    },
    [975] = {
        name = "HoF",
        id = 975,
        timerSteps = {},
    },
    [1000] = {
        name = "AS",
        id = 1000,
        timerSteps = {},
    },
    [1051] = {
        name = "CR",
        id = 1051,
        timerSteps = {},
    },
    [1121] = {
        name = "SS",
        id = 1121,
        timerSteps = {},
    },
    [1196] = {
        name = "KA",
        id = 1196,
        timerSteps = {},
    },
    [1082] = {
        name = "BRP",
        id = 1082,
        timerSteps = {},
    },
    [677] = {
        name = "MA",
        id = 677,
        timerSteps = {},
    },
    [635] = {
        name = "DSA",
        id = 635,
        timerSteps = {},
    },
}

-----------------------
---- Custom Timers ----
-----------------------
Speedrun.customTimerSteps = {
    [638] = { --AA
        [1] = "",
        [2] = "",
        [3] = "",
        [4] = "",
        [5] = "",
        [6] = "",
        [7] = "",
        [8] = ""
    },
    [636] = { --HRC
        [1] = "",
        [2] = "",
        [3] = "",
        [4] = "",
        [5] = "",
        [6] = ""
    },
    [639] = { --SO
        [1] = "",
        [2] = "",
        [3] = "",
        [4] = "",
        [5] = "",
        [6] = "",
        [7] = "",
        [8] = ""
    },
    [725] = { --MoL
        [1] = "",
        [2] = "",
        [3] = "",
        [4] = "",
        [5] = "",
        [6] = ""
    },
    [975] = { --HoF
        [1] = "",
        [2] = "",
        [3] = "",
        [4] = "",
        [5] = "",
        [6] = "",
        [7] = "",
        [8] = "",
        [9] = "",
        [10] = ""
    },
    [1000] = { --AS
        [1] = "",
        [2] = "",
        [3] = "",
        [4] = "",
        [5] = "",
        [6] = ""
    },
    [1051] = { --CR
        [1] = "",
        [2] = "",
        [3] = "",
        [4] = "",
        [5] = "",
        [6] = ""
    },
    [1121] = { --SS
        [1] = "",
        [2] = "",
        [3] = "",
        [4] = "",
        [5] = "",
        [6] = ""
    },
    [1196] = { --KA
        [1] = "",
        [2] = "",
        [3] = "",
        [4] = "",
        [5] = "",
        [6] = "",
        -- [7] = nil
    },
    [1082] = { --BRP
        [1] = "",
        [2] = "",
        [3] = "",
        [4] = "",
        [5] = "",
        [6] = ""
    },
    [677] = { --MA
        [1] = "",
        [2] = "",
        [3] = "",
        [4] = "",
        [5] = "",
        [6] = "",
        [7] = "",
        [8] = "",
        [9] = "",
        [10] = ""
    },
    [635] = { --DSA
        [1] = "",
        [2] = "",
        [3] = "",
        [4] = "",
        [5] = "",
        [6] = "",
        [7] = "",
        [8] = "",
        [9] = "",
        [10] = "",
    },
}

-------------------
---- Step List ----
-------------------
Speedrun.stepList = {
    [638] = { --AA
        [1] = zo_strformat(SI_SPEEDRUN_AA_BEGIN_LIGHTNING),
        [2] = zo_strformat(SI_SPEEDRUN_AA_FINISH_LIGHTNING),
        [3] = zo_strformat(SI_SPEEDRUN_AA_BEGIN_STONE),
        [4] = zo_strformat(SI_SPEEDRUN_AA_FINISH_STONE),
        [5] = zo_strformat(SI_SPEEDRUN_AA_BEGIN_VARLARIEL),
        [6] = zo_strformat(SI_SPEEDRUN_AA_FINISH_VARLARIEL),
        [7] = zo_strformat(SI_SPEEDRUN_AA_BEGIN_MAGE),
        [8] = zo_strformat(SI_SPEEDRUN_AA_FINISH_MAGE),
    },
    [636] = { --HRC
        [1] = zo_strformat(SI_SPEEDRUN_HRC_BEGIN_RAKOTU),
        [2] = zo_strformat(SI_SPEEDRUN_HRC_FINISH_RAKOTU),
        [3] = zo_strformat(SI_SPEEDRUN_HRC_BEGIN_SECOND),
        [4] = zo_strformat(SI_SPEEDRUN_HRC_FINISH_SECOND),
        [5] = zo_strformat(SI_SPEEDRUN_HRC_BEGIN_WARRIOR),
        [6] = zo_strformat(SI_SPEEDRUN_HRC_FINISH_WARRIOR),
    },
    [639] = { --SO
        [1] = zo_strformat(SI_SPEEDRUN_SO_BEGIN_MANTIKORA),
        [2] = zo_strformat(SI_SPEEDRUN_SO_FINISH_MANTIKORA),
        [3] = zo_strformat(SI_SPEEDRUN_SO_BEGIN_TROLL),
        [4] = zo_strformat(SI_SPEEDRUN_SO_FINISH_TROLL),
        [5] = zo_strformat(SI_SPEEDRUN_SO_BEGIN_OZARA),
        [6] = zo_strformat(SI_SPEEDRUN_SO_FINISH_OZARA),
        [7] = zo_strformat(SI_SPEEDRUN_SO_BEGIN_SERPENT),
        [8] = zo_strformat(SI_SPEEDRUN_SO_FINISH_SERPENT),
    },
    [725] = { --MoL
        [1] = zo_strformat(SI_SPEEDRUN_MOL_BEGIN_ZHAJ),
        [2] = zo_strformat(SI_SPEEDRUN_MOL_FINISH_ZHAJ),
        [3] = zo_strformat(SI_SPEEDRUN_MOL_BEGIN_TWINS),
        [4] = zo_strformat(SI_SPEEDRUN_MOL_FINISH_TWINS),
        [5] = zo_strformat(SI_SPEEDRUN_MOL_BEGIN_RAKKHAT),
        [6] = zo_strformat(SI_SPEEDRUN_MOL_FINISH_RAKKHAT),
    },
    [975] = { --HoF
        [1] = zo_strformat(SI_SPEEDRUN_HOF_BEGIN_DYNO),
        [2] = zo_strformat(SI_SPEEDRUN_HOF_FINISH_DYNO),
        [3] = zo_strformat(SI_SPEEDRUN_HOF_BEGIN_FACTOTUM),
        [4] = zo_strformat(SI_SPEEDRUN_HOF_FINISH_FACTOTUM),
        [5] = zo_strformat(SI_SPEEDRUN_HOF_BEGIN_SPIDER),
        [6] = zo_strformat(SI_SPEEDRUN_HOF_FINISH_SPIDER),
        [7] = zo_strformat(SI_SPEEDRUN_HOF_BEGIN_COMMITEE),
        [8] = zo_strformat(SI_SPEEDRUN_HOF_FINISH_COMMITEE),
        [9] = zo_strformat(SI_SPEEDRUN_HOF_BEGIN_ASSEMBLY),
        [10] = zo_strformat(SI_SPEEDRUN_HOF_FINISH_ASSEMBLY),
    },
    [1000] = { --AS
        [1] = zo_strformat(SI_SPEEDRUN_AS_BEGIN_OLMS),
        [2] = zo_strformat(SI_SPEEDRUN_AS_90_PERCENT),
        [3] = zo_strformat(SI_SPEEDRUN_AS_75_PERCENT),
        [4] = zo_strformat(SI_SPEEDRUN_AS_50_PERCENT),
        [5] = zo_strformat(SI_SPEEDRUN_AS_25_PERCENT),
        [6] = zo_strformat(SI_SPEEDRUN_AS_KILL_OLMS),
    },
    [1051] = { --CR
        [1] = zo_strformat(SI_SPEEDRUN_CR_BEGIN_ZMAJA),
        [2] = zo_strformat(SI_SPEEDRUN_CR_SIRORIA_APPEAR),
        [3] = zo_strformat(SI_SPEEDRUN_CR_RELEQUEN_APPEAR),
        [4] = zo_strformat(SI_SPEEDRUN_CR_GALENWE_APPEAR),
        [5] = zo_strformat(SI_SPEEDRUN_CR_SHADOW_APPEAR),
        [6] = zo_strformat(SI_SPEEDRUN_CR_KILL_SHADOW),
    },
    [1121] = { --SS
        [1] = zo_strformat(SI_SPEEDRUN_SS_BEGIN_FIRST),
        [2] = zo_strformat(SI_SPEEDRUN_SS_KILL_FIRST),
        [3] = zo_strformat(SI_SPEEDRUN_SS_BEGIN_SECOND),
        [4] = zo_strformat(SI_SPEEDRUN_SS_KILL_SECOND),
        [5] = zo_strformat(SI_SPEEDRUN_SS_BEGIN_LAST),
        [6] = zo_strformat(SI_SPEEDRUN_SS_KILL_LAST),
    },
    [1196] = { --KA
        [1] = zo_strformat(SI_SPEEDRUN_KA_BEGIN_YANDIR),
        [2] = zo_strformat(SI_SPEEDRUN_KA_KILL_YANDIR),
        [3] = zo_strformat(SI_SPEEDRUN_KA_BEGIN_VROL),
        [4] = zo_strformat(SI_SPEEDRUN_KA_KILL_VROL),
        [5] = zo_strformat(SI_SPEEDRUN_KA_BEGIN_FALGRAVN),
        [6] = zo_strformat(SI_SPEEDRUN_KA_KILL_FALGRAVN),
        -- [7] = "",
    },
    [1082] = { --BRP
        [1] = zo_strformat(SI_SPEEDRUN_ARENA_FIRST),
        [2] = zo_strformat(SI_SPEEDRUN_ARENA_SECOND),
        [3] = zo_strformat(SI_SPEEDRUN_ARENA_THIRD),
        [4] = zo_strformat(SI_SPEEDRUN_ARENA_FOURTH),
        [5] = zo_strformat(SI_SPEEDRUN_ARENA_FIFTH),
        [6] = zo_strformat(SI_SPEEDRUN_ARENA_COMPLETE),
    },
    [677] = { --MA
        [1] = zo_strformat(SI_SPEEDRUN_ARENA_FIRST),
        [2] = zo_strformat(SI_SPEEDRUN_ARENA_SECOND),
        [3] = zo_strformat(SI_SPEEDRUN_ARENA_THIRD),
        [4] = zo_strformat(SI_SPEEDRUN_ARENA_FOURTH),
        [5] = zo_strformat(SI_SPEEDRUN_ARENA_FIFTH),
        [6] = zo_strformat(SI_SPEEDRUN_ARENA_SIXTH),
        [7] = zo_strformat(SI_SPEEDRUN_ARENA_SEVENTH),
        [8] = zo_strformat(SI_SPEEDRUN_ARENA_EIGHTH),
        [9] = zo_strformat(SI_SPEEDRUN_ARENA_NINTH),
        [10] = zo_strformat(SI_SPEEDRUN_ARENA_TENTH),
    },
    [635] = { --DSA
        [1] = zo_strformat(SI_SPEEDRUN_ARENA_FIRST),
        [2] = zo_strformat(SI_SPEEDRUN_ARENA_SECOND),
        [3] = zo_strformat(SI_SPEEDRUN_ARENA_THIRD),
        [4] = zo_strformat(SI_SPEEDRUN_ARENA_FOURTH),
        [5] = zo_strformat(SI_SPEEDRUN_ARENA_FIFTH),
        [6] = zo_strformat(SI_SPEEDRUN_ARENA_SIXTH),
        [7] = zo_strformat(SI_SPEEDRUN_ARENA_SEVENTH),
        [8] = zo_strformat(SI_SPEEDRUN_ARENA_EIGHTH),
        [9] = zo_strformat(SI_SPEEDRUN_ARENA_NINTH),
        [10] = zo_strformat(SI_SPEEDRUN_ARENA_TENTH),
    },
}
