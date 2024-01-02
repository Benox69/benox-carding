ESX = exports["es_extended"]:getSharedObject()

local result


RegisterNetEvent('carding:openMenu')
AddEventHandler('carding:openMenu', function()
    Wait(500)
    local input = lib.inputDialog('MSR90', {
        {type = 'input', label = 'Card Number', description = Config.Locales['dialog_card_description'], required = true, min = 1},
        {type = 'input', label = 'CCV', description = Config.Locales['dialog_ccv_description'], required = true, min = 1},
        {type = 'date', label = 'Expiry date', description = Config.Locales['dialog_expiry_description'], required = true, icon = {'far', 'calendar'}, default = true, format = "DD/MM/YYYY"},
      })
      result = true
      number = input[1]
      ccv = tonumber(input[2])
      date = input[3]
      lib.callback('benox-carding:success', false, function()
      end, result, number, ccv, date)
end)

local IsPlayerNearATM = false



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		local playerPed = GetPlayerPed(-1)
		local x,y,z = table.unpack(GetEntityCoords(playerPed, true))
		if not IsPlayerNearATM then
			for k,v in pairs(Config.ATMList) do
				local ATM = GetClosestObjectOfType(x, y, z, 1.0, GetHashKey(v), false)
				   if DoesEntityExist(ATM) then
					currentATM = ATM
					ATMX, ATMY, ATMZ = table.unpack(GetOffsetFromEntityInWorldCoords(ATM, 0.0, -.85, 0.0))
					IsPlayerNearATM = true
				end
			end
		else
			if not DoesEntityExist(currentATM) then
				IsPlayerNearATM = false
			else
				if GetDistanceBetweenCoords(x,y,z, ATMX, ATMY, ATMZ, true) > Config.AtmDistance then
					IsPlayerNearATM = false
				end
			end
		end
	end
end)



exports('benox:useCard', function(data, slot)
  if IsPlayerNearATM then
    number = slot.metadata.number
    ccv = slot.metadata.ccv
    date = slot.metadata.date
    lib.callback('benox:checkCard', false, function()
    end, number, ccv, date)
  else

    return
  end

end)

RegisterNetEvent('benox:hackGame', function (source, money)
  local success = showMiniGame()
  if success then
    lib.callback('benox:addMoney', false, function()
    end, success, source, money)
  else
    return
  end

end)
