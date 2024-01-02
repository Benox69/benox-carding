ESX = exports["es_extended"]:getSharedObject()


RegisterCommand('generateCards', function (source, args)
    
    local amountOfCards = args[1]
    if amountOfCards == nil then
        sendNotify(Config.Locales['empty_card_number'], source, 'error')
    else
        sendNotify(Config.Locales['created_cards'], source, 'success')
        for i = 1, amountOfCards do
            card = math.random(1000,9999) .. '-' .. math.random(1000,9999) .. '-' .. math.random(1000,9999) .. '-' .. math.random(1000,9999)
            ccv = math.random(100, 999)
            local year = math.random(2024, 2030)
            local month = string.format("%02d", math.random(1, 12))
            local day = string.format("%02d", math.random(1, 28))
            local date = year .. '-' .. month .. '-' .. day
            money = generateRandomNumber()
            MySQL.insert('INSERT INTO available_cards (card_number, ccv, date, money) VALUES(?, ?, ?, ?)',{
                card,
                ccv,
                date,
                money
            })
            
        end
    end
    
end, true)

local ox_inventory = exports.ox_inventory

local card = {}

local combine = exports.ox_inventory:registerHook('swapItems', function(payload)
    local fromSlot = payload.fromSlot
    local toSlot = payload.toSlot
    if type(fromSlot) == "table" and type(toSlot) == "table" then
        if payload.fromInventory == payload.source and fromSlot ~= nil and toSlot ~= nil and fromSlot.name == 'blank_card' and toSlot.name == 'msr90' then
            TriggerClientEvent('ox_inventory:closeInventory', payload.source)
            TriggerClientEvent('carding:openMenu', payload.source)
            card = {
                name = payload.fromSlot.name,
                amount = 1,
                slot = payload.fromSlot.slot,
                metadata = payload.fromSlot.metadata
            }
            return false
        end
    end

end,{})



function turnDateToNormal(timestamp)
    local date = math.floor(timestamp / 1000)
    date = os.date('%Y-%m-%d', date)
    return date
end

local success

lib.callback.register('benox-carding:success', function(source, success, number, ccv, date)
    if not card then return end
    if success then
        ox_inventory:RemoveItem(source, card.name, card.amount, card.metadata, card.slot)
        ox_inventory:AddItem(source, card.name, card.amount, {description = 'Number: ' .. number .. ' CCV: ' .. ccv .. ' Date: ' .. turnDateToNormal(date), number = number, ccv = ccv, date = turnDateToNormal(date)}, card.slot)
    end
    card = nil
end)
lib.callback.register('benox:checkCard', function(source, number, ccv, date)
    local playerId = source
    local identifier = GetPlayerIdentifierByType(playerId, 'license')

    MySQL.query('SELECT * from available_cards' ,{
    }, function(results)
        -- print(json.encode(results[1]))
        for i=1, #results do
            if tostring(results[i].card_number) == tostring(number) then
                
                if results[i].ccv == tonumber(ccv) then
                    if date == results[i].date then
                        TriggerClientEvent('benox:hackGame', source, results[i].money)
                        deleteTable = function ()
                            MySQL.query('DELETE FROM available_cards WHERE card_number = @number AND ccv = @ccv AND date = @date', {
                                ['@number'] = number,
                                ['@ccv'] = ccv,
                                ['@date'] = date
                              })
                        end
                    end
                end
            end
        end
    end)

end)

function GetPlayer(source)
    return ESX.GetPlayerFromId(source)
end

function AddMoney(source, amount)
    local playerData = GetPlayer(source)
    playerData.addAccountMoney('money', amount)
end

lib.callback.register('benox:addMoney', function(source, success, money)
    if success then
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addAccountMoney(Config.AccountMoney, tonumber(money))
        deleteTable()
    end
end)



