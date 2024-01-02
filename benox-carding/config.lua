-- installation:
-- 1. Add SQL to your database
-- 2. Add this to '\ox_inventory\data\items.lua'
/*[
'msr90'] = {
    label = 'MSR90',
    weight = 220,
    stack = false,
    consume = 0,
},
['blank_card'] = {
    label = 'Blank Card',
    weight = 220,
    stack = false,
    client = {
        export = 'benox-carding.benox:useCard',
    },
    consume = 0,
}
*/
-- 3. Add icons to 'ox_inventory\web\images'

Config = {}

Config.ATMList = {'prop_atm_01', 'prop_atm_02', 'prop_atm_03', 'prop_fleeca_atm'}


Config.AtmDistance = 2.0

Config.Locales = {
    ['empty_card_number'] = 'Jūs neįvedetė kortelių skaičiaus',
    ['created_cards'] = "Jūs sukūrėtė korteles!",
    ['dialog_card_description'] = "Card Numbers you bought from hackers",
    ['dialog_ccv_description'] = "CCV you bought from hackers",
    ['dialog_expiry_description'] = "Card Expiry date"
}
Config.AccountMoney = 'black_money'

function generateRandomNumber()
    local randomNumber = math.random()

    -- 10% chance of generating a 4-digit number
    if randomNumber <= 0.1 then
        return math.random(1000, 9999)
    end

    -- 70% chance of generating a 3-digit number
    return math.random(100, 999)
end

sendNotify = function (msg, source, type)
    if type == "error" then
        TriggerClientEvent('okokNotify:Alert', source, "Klaida!", msg, 3000, type)
    end
    if type == "success" then
        TriggerClientEvent('okokNotify:Alert', source, "Puiku!", msg, 3000, type)
    end
end

showMiniGame = function ()
    success = exports['howdy-hackminigame']:Begin(3, 5000)
    return success
end

-- 