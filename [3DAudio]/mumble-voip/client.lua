local voiceData = {}
local radioData = {}
local callData = {}

local playerServerId = GetPlayerServerId(PlayerId())

-- Functions
function SetVoiceData(key, value)
	TriggerServerEvent("mumble:SetVoiceData", key, value)
end

-- Events
RegisterNetEvent("mumble:SetVoiceData")
AddEventHandler("mumble:SetVoiceData", function(voice, radio, call)
	voiceData = voice

	if radio then
		radioData = radio
	end

	if call then
		callData = call
	end
end)

RegisterNetEvent("mumble:RadioSound")
AddEventHandler("mumble:RadioSound", function(snd, channel)
	if channel <= mumbleConfig.radioClickMaxChannel then
		if mumbleConfig.micClicks then
			if (snd and mumbleConfig.micClickOn) or (not snd and mumbleConfig.micClickOff) then
				SendNUIMessage({ sound = (snd and "audio_on" or "audio_off"), volume = mumbleConfig.micClickVolume })
			end
		end
	end
end)

AddEventHandler("onClientResourceStart", function (resourceName)
	if GetCurrentResourceName() ~= resourceName then
		return
	end

	TriggerServerEvent("mumble:Initialise")
end)

-- Keybinds
RegisterCommand("+voiceMode", function()
	local playerData = voiceData[playerServerId]
	local voiceMode = 2

	if playerData then
		voiceMode = playerData.mode
	end

	local newMode = voiceMode + 1

	if newMode > #mumbleConfig.voiceModes then
		voiceMode = 1
	else
		voiceMode = newMode
	end

	SetVoiceData("mode", voiceMode)
end)

RegisterCommand("-voiceMode", function()
	
end)

RegisterCommand("+radio", function()
	if mumbleConfig.radioEnabled then
		local playerData = voiceData[playerServerId]


		if playerData then
			if playerData.radio ~= nil then
				if playerData.radio > 0 then
					SetVoiceData("radioActive", true)
				end
			end
		end
	end
end)

RegisterCommand("-radio", function()
	local playerData = voiceData[playerServerId]


	if playerData then
		if playerData.radio ~= nil then
			if playerData.radio > 0 then
				if playerData.radioActive then
					SetVoiceData("radioActive", false)
				end
			end
		end
	end
end)

RegisterCommand("+speaker", function()
	if mumbleConfig.radioSpeakerEnabled then
		local playerData = voiceData[playerServerId]

		if playerData then
			if playerData.radio ~= nil then
				if playerData.call > 0 then
					SetVoiceData("callSpeaker", not playerData.callSpeaker)
				end
			end
		end
	end
end)

RegisterCommand("-speaker", function()

end)

RegisterKeyMapping("+voiceMode", "Change voice distance", "keyboard", mumbleConfig.controls.proximity)
RegisterKeyMapping("+radio", "Talk on the radio", "keyboard", mumbleConfig.controls.radio)
RegisterKeyMapping("+speaker", "Toggle speaker mode", "keyboard", mumbleConfig.controls.speaker)

-- Simulate PTT when radio is active
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerData = voiceData[playerServerId]
		local playerRadioActive = false

		if playerData ~= nil then
			playerRadioActive = playerData.radioActive or false
		end

		if playerRadioActive then -- Force PTT enabled
			SetControlNormal(0, 171, 1.0)
			SetControlNormal(1, 171, 1.0)
			SetControlNormal(2, 171, 1.0)
		end
	end
end)

-- UI
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(200)
		local playerId = PlayerId()
		local playerData = voiceData[playerServerId]
		local playerTalking = NetworkIsPlayerTalking(playerId)
		local playerMode = 2
		local playerRadio = 0
		local playerRadioActive = false
		local playerCall = 0
		local playerCallSpeaker = false

		if playerData ~= nil then
			playerMode = playerData.mode or 2
			playerRadio = playerData.radio or 0
			playerRadioActive = playerData.radioActive or false
			playerCall = playerData.call or 0
			playerCallSpeaker = playerData.callSpeaker or false
		end

		-- Update UI
		SendNUIMessage({
			talking = playerTalking,
			mode = mumbleConfig.voiceModes[playerMode][2],
			radio = mumbleConfig.radioChannelNames[playerRadio] ~= nil and mumbleConfig.radioChannelNames[playerRadio] or playerRadio,
			radioActive = playerRadioActive,
			call = playerCall,
			speaker = playerCallSpeaker,
		})
	end
end)

-- Main thread
Citizen.CreateThread(function()
	local talkingAnim = { "mic_chatter", "mp_facial" }
	local normalAnim = { "mood_normal_1", "facials@gen_male@base" }

	RequestAnimDict(talkingAnim[3])

	while not HasAnimDictLoaded(talkingAnim[2]) do
		Citizen.Wait(150)
	end

	RequestAnimDict(normalAnim[2])

	while not HasAnimDictLoaded(normalAnim[2]) do
		Citizen.Wait(150)
	end

	while true do
		Citizen.Wait(500)

		local playerId = PlayerId()
		local playerPed = PlayerPedId()
		local playerPos = GetPedBoneCoords(playerPed, headBone)
		local playerList = GetActivePlayers()
		local playerData = voiceData[playerServerId]
		local playerRadio = 0
		local playerCall = 0

		if playerData ~= nil then
			playerRadio = playerData.radio or 0
			playerCall = playerData.call or 0
		end

		local voiceList = {}
		local muteList = {}
		local callList = {}
		local radioList = {}

		for i = 1, #playerList do -- Proximity based voice (probably won't work for infinity?)
			local remotePlayerId = playerList[i]

			if playerId ~= remotePlayerId then
				local remotePlayerServerId = GetPlayerServerId(remotePlayerId)
				local remotePlayerPed = GetPlayerPed(remotePlayerId)
				local remotePlayerPos = GetPedBoneCoords(remotePlayerPed, headBone)
				local remotePlayerData = voiceData[remotePlayerServerId]

				local distance = #(playerPos - remotePlayerPos)
				local mode = 2
				local radio = 0
				local radioActive = false
				local call = 0
				local callSpeaker = false

				if remotePlayerData ~= nil then
					mode = remotePlayerData.mode or 2
					radio = remotePlayerData.radio or 0
					radioActive = remotePlayerData.radioActive or false
					call = remotePlayerData.call or 0
					callSpeaker = remotePlayerData.callSpeaker or false
				end

				-- Mouth animations
				if mumbleConfig.faceAnimations then
					if distance < 50 then
						local remotePlayerTalking = NetworkIsPlayerTalking(remotePlayerId)
						
						if remotePlayerTalking then
							PlayFacialAnim(remotePlayerPed, talkingAnim[1], talkingAnim[2])
						else
							PlayFacialAnim(remotePlayerPed, normalAnim[1], normalAnim[2])
						end
					end
				end

				-- Check if player is in range
				if distance < mumbleConfig.voiceModes[mode][1] then
					local volume = 1.0 - (distance / mumbleConfig.voiceModes[mode][1])^0.5

					if volume < 0 then
						volume = 0.0
					end

					voiceList[#voiceList + 1] = {
						id = remotePlayerServerId,
						player = remotePlayerId,
						volume = volume,
					}

					if mumbleConfig.callSpeakerEnabled then
						if call > 0 then -- Collect all players in the phone call
							if callSpeaker then
								local callParticipants = callData[call]
								if callParticipants ~= nil then
									for id, _ in pairs(callParticipants) do
										if id ~= remotePlayerServerId then
											callList[id] = true
										end
									end
								end
							end
						end
					end
					
					if mumbleConfig.radioSpeakerEnabled then
						if radio > 0 then -- Collect all players in the radio channel
							local radioParticipants = radioData[radio]
							if radioParticipants then
								for id, _ in pairs(radioParticipants) do
									if id ~= remotePlayerServerId then
										radioList[id] = true
									end
								end
							end
						end
					end
				else
					muteList[#muteList + 1] = {
						id = remotePlayerServerId,
						player = remotePlayerId,
						volume = 0.0,
						radio = radio,
						radioActive = radioActive,
						distance = distance,
						call = call,
					}					
				end
			end
		end

		for j = 1, #voiceList do
			MumbleSetVolumeOverride(voiceList[j].player, voiceList[j].volume)
		end

		for j = 1, #muteList do
			if callList[muteList[j].id] or radioList[muteList[j].id] then
				if muteList[j].distance < mumbleConfig.speakerRange then
					muteList[j].volume = 1.0 - (muteList[j].distance / mumbleConfig.speakerRange)^0.5
				end
			end

			if muteList[j].radio > 0 and muteList[j].radio == playerRadio and muteList[j].radioActive then
				muteList[j].volume = 1.0
			end

			if muteList[j].call > 0 and muteList[j].call == playerCall then
				muteList[j].volume = 1.2
			end
			
			MumbleSetVolumeOverride(muteList[j].player, muteList[j].volume)
		end
	end
end)

-- Exports
function SetRadioChannel(channel)
	local channel = tonumber(channel)

	if channel ~= nil then
		SetVoiceData("radio", channel)
	end
end

function SetCallChannel(channel)
	local channel = tonumber(channel)

	if channel ~= nil then
		SetVoiceData("call", channel)
	end
end

exports("SetRadioChannel", SetRadioChannel)
exports("addPlayerToRadio", SetRadioChannel)
exports("removePlayerFromRadio", function()
	SetRadioChannel(0)
end)

exports("SetCallChannel", SetCallChannel)
exports("addPlayerToCall", SetCallChannel)
exports("removePlayerFromCall", function()
	SetCallChannel(0)
end)