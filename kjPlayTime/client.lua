QBCore = nil
Citizen.CreateThread(function()
	while QBCore == nil do
	  TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
	  Citizen.Wait(1)
	end
end)

local firstSpawn = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
	if firstSpawn == false then
		Citizen.Wait(5000)
		TriggerServerEvent('totalplayed-timed:loggedIn', GetPlayerName(PlayerId()))
		firstSpawn = true
	end
end)

local npcCo = vector3(162.026, -1269.0, 14.1988)
Citizen.CreateThread(function()
    local throw = "a_m_y_business_03"
    RequestModel(throw)
    while not HasModelLoaded(throw) do
        Citizen.Wait(100)
    end
    thrown = CreatePed(26, GetHashKey(throw), npcCo, 95.99, false, true)
end)

local busy = false
Citizen.CreateThread(function()
    while true do
        local time = 2000
        local ped = PlayerPedId()
        local pedCo = GetEntityCoords(ped)
        local dist = #(npcCo - pedCo)

        if dist <= 2.0 and not busy then
            time = 1
            DrawText3D(162.026, -1269.0, 14.1988, "[E] Antrenman Yap")
            if IsControlJustPressed(0, 38) then
                busy = true
                FightAnim()
            end
        end
        Citizen.Wait(time)
    end
end)

function DrawText3D(x, y, z, text)
	SetTextScale(0.30, 0.30)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 250
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local thrown

FightAnim = function()
    local animDict = "misschinese1leadinoutchinese_1_int"
    local ped = GetPlayerPed(-1)
    local throw = "u_m_y_babyd"
    local x,y,z = table.unpack(GetEntityCoords(ped))
    coords = GetEntityCoords(ped)
    RequestAnimDict(animDict)
    RequestModel(throw)
    while not HasAnimDictLoaded(animDict) or not HasModelLoaded(throw) do
        Citizen.Wait(100)
    end
    local targetPosition, targetRotation = vector3(166.300, -1261.9, 10.8522), vec3(0.0, 0.0, 0.0)
    -- FreezeEntityPosition(ped, true)
    TaskGoToPed()
    Citizen.Wait(15000)
    FreezeEntityPosition(thrown, true)
    LoadingPrompt()
    local netScene = NetworkCreateSynchronisedScene(targetPosition.x, targetPosition.y, targetPosition.z -0.95, targetRotation, 2, false, false, 1065353216, 0, 1065353216)
    NetworkAddPedToSynchronisedScene(ped, netScene, animDict, "russ_leadin_action", 1.0, -4.0, 157, 92, 1148846080, 0)
    NetworkAddPedToSynchronisedScene(thrown, netScene, animDict, "husb_leadin_action", 1.0, -4.0, 157, 92, 1148846080, 0)
    NetworkStartSynchronisedScene(netScene)
    Citizen.Wait(17500)
    NetworkStopSynchronisedScene(netScene)
    FreezeEntityPosition(ped, false)
    RemoveAnimDict(animDict)
    DeletePed(thrown)
	exports["gamz-skillsystem"]:UpdateSkill("Kondisyon", 0.30)
	exports["gamz-skillsystem"]:UpdateSkill("Güç", 0.30)
    busy = false
end

TaskGoToPed = function()
    local throw = "u_m_y_babyd"
    RequestModel(throw)
    while not HasModelLoaded(throw) do
        Citizen.Wait(100)
    end
    thrown = CreatePed(26, GetHashKey(throw), vector3(163.211, -1274.8, 14.1988), false, true)
    TaskGoToEntity(thrown, PlayerPedId(), 50000, 5, 1.0, 1,1)
end

function LoadingPrompt()
    QBCore.Functions.Notify("3", "primary")
    PlaySoundFrontend(-1, "RACE_PLACED", "HUD_AWARDS")
    Wait(1000)
    QBCore.Functions.Notify("2", "primary")
    PlaySoundFrontend(-1, "RACE_PLACED", "HUD_AWARDS")
    Wait(1000)
    QBCore.Functions.Notify("1", "primary")
    PlaySoundFrontend(-1, "RACE_PLACED", "HUD_AWARDS")
    Wait(1000)
    QBCore.Functions.Notify("Başla!", "primary")
end