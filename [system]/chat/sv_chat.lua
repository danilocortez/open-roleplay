-- DEFAULT --
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
-- WEBHOOK
local webhooklink = "https://discordapp.com/api/webhooks/714879927631216691/pIdhdIvT0xlJcGVE6DfGvyv2KAiv7m9a_ove0ZOmCAbvcBXDt7GK-cAm1G9EPOLXPz72"

function SendWebhookMessage(webhook,message)
    if webhook ~= nil and webhook ~= "" then
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
    end
end
--

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP")
BMclient = Tunnel.getInterface("vRP_basic_menu","vRP_basic_menu")

RegisterServerEvent('chat:init')
RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('_chat:messageEntered')
RegisterServerEvent('chat:clear')
RegisterServerEvent('__cfx_internal:commandFallback')

Citizen.CreateThread(function()
	ac_webhook_joins = GetConvar("ac_webhook_joins", "https://discordapp.com/api/webhooks/714879927631216691/pIdhdIvT0xlJcGVE6DfGvyv2KAiv7m9a_ove0ZOmCAbvcBXDt7GK-cAm1G9EPOLXPz72")
	ac_webhook_gameplay = GetConvar("ac_webhook_gameplay", "https://discordapp.com/api/webhooks/714879927631216691/pIdhdIvT0xlJcGVE6DfGvyv2KAiv7m9a_ove0ZOmCAbvcBXDt7GK-cAm1G9EPOLXPz72")
	ac_webhook_bans = GetConvar("ac_webhook_bans", "https://discordapp.com/api/webhooks/714879927631216691/pIdhdIvT0xlJcGVE6DfGvyv2KAiv7m9a_ove0ZOmCAbvcBXDt7GK-cAm1G9EPOLXPz72")
	ac_webhook_wl = GetConvar("ac_webhook_wl", "https://discordapp.com/api/webhooks/714879927631216691/pIdhdIvT0xlJcGVE6DfGvyv2KAiv7m9a_ove0ZOmCAbvcBXDt7GK-cAm1G9EPOLXPz72")
	ac_webhook_arsenal = GetConvar("ac_webhook_arsenal", "https://discordapp.com/api/webhooks/714879927631216691/pIdhdIvT0xlJcGVE6DfGvyv2KAiv7m9a_ove0ZOmCAbvcBXDt7GK-cAm1G9EPOLXPz72")

	function SendWebhookMessage(webhook,message)
		if webhook ~= "none" then
			PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
		end
	end
end)


AddEventHandler('_chat:messageEntered', function(author, color, message)
    if not message or not author then
        return
    end

    if not WasEventCanceled() then
		TriggerClientEvent('sendProximityMessage', -1, source, author, message, color)
    end
end)

AddEventHandler('__cfx_internal:commandFallback', function(command)
    local name = GetPlayerName(source)

    if not WasEventCanceled() then
    end
    CancelEvent()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLÍCIA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('190', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id ~= nil then
		local player = vRP.getUserSource(user_id)
		local identity = vRP.getUserIdentity(user_id)
		TriggerClientEvent('chatMessage', -1, "[190] ".. identity.name .. " " .. identity.firstname .." ", {0, 0, 255}, rawCommand:sub(4))
		SendWebhookMessage(webhooklink, "**ID "..user_id.." ".. identity.name .. "" .. identity.firstname .."** enviou no **/190:** " ..rawCommand.. " ")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARAMÉDICOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('192', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id ~= nil then
		local player = vRP.getUserSource(user_id)
		local identity = vRP.getUserIdentity(user_id)
		TriggerClientEvent('chatMessage', -1, "[192] ".. identity.name .. " " .. identity.firstname .." ", {255, 50, 100}, rawCommand:sub(4))
		SendWebhookMessage(webhooklink, "**ID "..user_id.." ".. identity.name .. "" .. identity.firstname .."** enviou no **/192:** " ..rawCommand.. " ")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TWITTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('twt', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id ~= nil then
		local player = vRP.getUserSource(user_id)
		local identity = vRP.getUserIdentity(user_id)
		TriggerClientEvent('chatMessage', -1, "[Twitter] @".. identity.name .. " " .. identity.firstname .." ", {0, 170, 255}, rawCommand:sub(4))
		SendWebhookMessage(webhooklink, "**ID "..user_id.." ".. identity.name .. "" .. identity.firstname .."** enviou no **/twt:** " ..rawCommand.. " ")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TWITTER2
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('twitter', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id ~= nil then
		local player = vRP.getUserSource(user_id)
		local identity = vRP.getUserIdentity(user_id)
		TriggerClientEvent('chatMessage', -1, "[Twitter] @".. identity.name .. " " .. identity.firstname .." ", {0, 170, 255}, rawCommand:sub(8))
		SendWebhookMessage(webhooklink, "**ID "..user_id.." ".. identity.name .. "" .. identity.firstname .."** enviou no **/twitter:** " ..rawCommand.. " ")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ILEGAL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ilegal', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id ~= nil then
		local player = vRP.getUserSource(user_id)
		local identity = vRP.getUserIdentity(user_id)
		TriggerClientEvent('chatMessage', -1, "[Anônimo]", {000, 000, 000}, rawCommand:sub(7))
		SendWebhookMessage(webhooklink, "**ID "..user_id.." ".. identity.name .. "" .. identity.firstname .."** enviou no **/ilegal:** " ..rawCommand.. " ")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MECANICO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('mec', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id ~= nil then
		local player = vRP.getUserSource(user_id)
		local identity = vRP.getUserIdentity(user_id)
		TriggerClientEvent('chatMessage', -1, "[Mecânicos] ".. identity.name .. " " .. identity.firstname .." ", {218, 165, 32}, rawCommand:sub(4))
		SendWebhookMessage(webhooklink, "**ID "..user_id.." ".. identity.name .. "" .. identity.firstname .."** enviou no **/mec:** " ..rawCommand.. " ")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FORA RP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('frp', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id ~= nil then
		local player = vRP.getUserSource(user_id)
		local identity = vRP.getUserIdentity(user_id)
		TriggerClientEvent('chatMessage', -1, "[Fora RP] ".. GetPlayerName(source) .." ("..user_id..") ", {25, 102, 25}, rawCommand:sub(4))
		SendWebhookMessage(webhooklink, "**ID "..user_id.." ".. identity.name .. "" .. identity.firstname .."** enviou no **/frp:** " ..rawCommand.. " ")
		CancelEvent()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HELP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('help', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id ~= nil then
		local player = vRP.getUserSource(user_id)
		local identity = vRP.getUserIdentity(user_id)
		TriggerClientEvent('chatMessage', -1, "[AJUDA] ".. GetPlayerName(source) .." | ".. identity.name .."  " .. identity.firstname .." (ID "..user_id..") ", {255, 0, 127}, rawCommand:sub(5))
		SendWebhookMessage(webhooklink, "**ID "..user_id.." ".. identity.name .. "" .. identity.firstname .."** enviou no **/help:** " ..rawCommand.. " ")
		CancelEvent()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACAO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('acao', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id ~= nil then
		local player = vRP.getUserSource(user_id)
		local identity = vRP.getUserIdentity(user_id)
		TriggerClientEvent('chatMessage', -1, "[Ação] ".. identity.name .." ".. identity.firstname .." ("..user_id..") ", {128, 0, 128}, rawCommand:sub(5))
		SendWebhookMessage(webhooklink, "**ID "..user_id.." ".. identity.name .. "" .. identity.firstname .."** enviou no **/acao:** " ..rawCommand.. " ")
		CancelEvent()
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SUGESTÃO DE COMANDOS
-----------------------------------------------------------------------------------------------------------------------------------------
local function refreshCommands(player)
    if GetRegisteredCommands then
        local registeredCommands = GetRegisteredCommands()

        local suggestions = {}

        for _, command in ipairs(registeredCommands) do
            if IsPlayerAceAllowed(player, ('command.%s'):format(command.name)) then
                table.insert(suggestions, {
                    name = '/' .. command.name,
                    help = ''
                })
            end
        end

        TriggerClientEvent('chat:addSuggestions', player, suggestions)
    end
end

AddEventHandler('chat:init', function()
    refreshCommands(source)
end)

AddEventHandler('onServerResourceStart', function(resName)
    Wait(500)

    for _, player in ipairs(GetPlayers()) do
        refreshCommands(player)
    end
end)