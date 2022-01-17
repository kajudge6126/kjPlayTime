local playersDataActuall, timedata = {}, {}

function SecondsToClock(seconds)
    if seconds ~= nil then
        local seconds = tonumber(seconds)

        if seconds <= 0 then
            return "00:00:00";
        else
            hours = string.format("%02.f", math.floor(seconds/3600));
            mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
            secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
            return hours..":"..mins..":"..secs
        end
    end
end

function dropPlayer(source)
    local identifier = GetPlayerIdentifiers(source)[1]
    local actuallTime = os.time()
    local name = GetPlayerName(source)
    if(timedata[identifier] ~= nil and playersDataActuall[identifier] ~= nil) then
        local time = tonumber(actuallTime - playersDataActuall[identifier])
        local timeFormatted = SecondsToClock(time)
        local timeAll = time + timedata[identifier]["time31"]
        local timeAllFormatted = SecondsToClock(timeAll)

        timedata[identifier] = {time31 = timeAll, login = timedata[identifier]["login"]}
        SaveResourceFile(GetCurrentResourceName(), "data.json", json.encode(timedata))
    else

    end
end

AddEventHandler('playerDropped', function(reason)    
	dropPlayer(source, reason)
end)

RegisterNetEvent('totalplayed-timed:loggedIn')
AddEventHandler('totalplayed-timed:loggedIn', function(playerName)
	local _source = source	
    local _playerName = playerName
    local identifier = GetPlayerIdentifiers(_source)[1]
    local actuallTime = os.time()
   
    if timedata[identifier] ~= nil then
        playersDataActuall[identifier] = actuallTime
        local totaltimeFormatted = SecondsToClock(timedata[identifier]["time31"])
        timedata[identifier] = {time31 = timedata[identifier]["time31"], login = timedata[identifier]["login"] + 1}
        SaveResourceFile(GetCurrentResourceName(), "data.json", json.encode(timedata))
        TriggerClientEvent("QBCore:Notify", source, "Sunucuya hoş geldin! Sunucuda toplam geçirdiğin süre: "..totaltimeFormatted.." Bu sunucuya " ..timedata[identifier]["login"] ..". girişin.")
    else
        playersDataActuall[identifier] = actuallTime
        timedata[identifier] = {time31 = 0, login = 1}
        SaveResourceFile(GetCurrentResourceName(), "data.json", json.encode(timedata))
    end
end)

CreateThread(function()
    local result = json.decode(LoadResourceFile(GetCurrentResourceName(), "data.json"))

    if result then
        timedata = result
    end
end)