--v function()
local function testLOG_reset()
	if not __write_output_to_logfile then
		return
	end
	local logTimeStamp = os.date("%d, %m %Y %X")
	--# assume logTimeStamp: string
	local popLog = io.open("test_log.txt","w+")
	popLog :write("NEW LOG ["..logTimeStamp.."] \n")
	popLog :flush()
	popLog :close()
end

--v function(text: string | number | boolean | CA_CQI)
local function testLOG(text)
	if not __write_output_to_logfile then
		return
	end
	local logText = tostring(text)
	local logTimeStamp = os.date("%d, %m %Y %X")
	local popLog = io.open("test_log.txt","a")
	--# assume logTimeStamp: string
	popLog :write("TEST:  [".. logTimeStamp .. "]:  [Turn: ".. tostring(cm:turn_number()) .. "]:  "..logText .. "  \n")
	popLog :flush()
	popLog :close()
end

--v function()
local function expCheat()
	local playerFaction = cm:get_faction(cm:get_local_faction(true))
    local characterList = playerFaction:character_list()
    for i = 0, characterList:num_items() - 1 do
        local currentChar = characterList:item_at(i)	
        local cqi = currentChar:command_queue_index()
        cm:add_agent_experience(cm:char_lookup_str(cqi), 70000)
    end
end

--v function()
local function unitCheat()
	local TKunitstring = {"wh2_dlc09_tmb_inf_tomb_guard_1",
						"wh2_dlc09_tmb_inf_tomb_guard_1",
						"wh2_dlc09_tmb_inf_tomb_guard_1",
						"wh2_dlc09_tmb_inf_tomb_guard_1",
						"wh2_dlc09_tmb_inf_tomb_guard_1",
						"wh2_dlc09_tmb_inf_tomb_guard_1",
						"wh2_dlc09_tmb_inf_tomb_guard_1",
						"wh2_dlc09_tmb_inf_tomb_guard_1",
						"wh2_dlc09_tmb_inf_tomb_guard_1",
						"wh2_dlc09_tmb_inf_tomb_guard_1",
						"wh2_dlc09_tmb_veh_khemrian_warsphinx_0",
						"wh2_dlc09_tmb_veh_khemrian_warsphinx_0",
						"wh2_dlc09_tmb_mon_necrosphinx_0",
						"wh2_dlc09_tmb_mon_necrosphinx_0",
						"wh2_pro06_tmb_mon_bone_giant_0",
						"wh2_pro06_tmb_mon_bone_giant_0",
						"wh2_pro06_tmb_mon_bone_giant_0",
						"wh2_pro06_tmb_mon_bone_giant_0",
						"wh2_pro06_tmb_mon_bone_giant_0"} --:vector<string>
	local DEFunitstring = {"wh2_main_def_inf_black_guard_0",
						"wh2_main_def_inf_black_guard_0",
						"wh2_main_def_inf_black_guard_0",
						"wh2_main_def_inf_black_guard_0",
						"wh2_main_def_inf_black_guard_0",
						"wh2_main_def_inf_black_guard_0",
						"wh2_main_def_inf_black_guard_0",
						"wh2_main_def_inf_black_guard_0",
						"wh2_main_def_inf_black_guard_0",
						"wh2_main_def_mon_black_dragon",
						"wh2_main_def_mon_black_dragon",
						"wh2_main_def_mon_black_dragon",
						"wh2_main_def_mon_black_dragon",
						"wh2_main_def_mon_black_dragon",
						"wh2_main_def_mon_black_dragon",
						"wh2_main_def_mon_black_dragon",
						"wh2_main_def_mon_black_dragon",
						"wh2_main_def_mon_black_dragon",
						"wh2_main_def_mon_black_dragon"} --:vector<string>
	local VMPunitstring = {"wh_main_vmp_inf_grave_guard_0",
						"wh_main_vmp_inf_grave_guard_0",
						"wh_main_vmp_inf_grave_guard_0",
						"wh_main_vmp_inf_grave_guard_0",
						"wh_main_vmp_inf_grave_guard_0",
						"wh_main_vmp_inf_grave_guard_0",
						"wh_main_vmp_inf_grave_guard_0",
						"wh_main_vmp_inf_grave_guard_0",
						"wh_main_vmp_inf_grave_guard_0",
						"wh_main_vmp_mon_terrorgheist",
						"wh_main_vmp_mon_terrorgheist",
						"wh_main_vmp_mon_terrorgheist",
						"wh_main_vmp_mon_terrorgheist",
						"wh_main_vmp_mon_terrorgheist",
						"wh_main_vmp_mon_terrorgheist",
						"wh_main_vmp_mon_terrorgheist",
						"wh_main_vmp_mon_terrorgheist",
						"wh_main_vmp_mon_terrorgheist",
						"wh_main_vmp_mon_terrorgheist"} --:vector<string>
	local LZDunitstring = {"wh2_dlc12_lzd_mon_ancient_stegadon_1",
						"wh2_dlc12_lzd_mon_ancient_stegadon_1",
						"wh2_dlc12_lzd_mon_ancient_stegadon_1",
						"wh2_dlc12_lzd_mon_ancient_stegadon_1",
						"wh2_dlc12_lzd_mon_ancient_stegadon_1",
						"wh2_dlc12_lzd_mon_ancient_stegadon_1",
						"wh2_dlc12_lzd_mon_ancient_stegadon_1",
						"wh2_dlc12_lzd_mon_ancient_stegadon_1",
						"wh2_dlc12_lzd_mon_ancient_stegadon_1",
						"wh2_dlc12_lzd_mon_ancient_stegadon_1",
						"wh2_dlc12_lzd_mon_ancient_stegadon_1",
						"wh2_dlc12_lzd_mon_ancient_stegadon_1",
						"wh2_dlc12_lzd_mon_ancient_stegadon_1",
						"wh2_dlc12_lzd_mon_ancient_stegadon_1",
						"wh2_dlc12_lzd_mon_ancient_stegadon_1",
						"wh2_dlc12_lzd_mon_ancient_stegadon_1",
						"wh2_dlc12_lzd_mon_ancient_stegadon_1",
						"wh2_dlc12_lzd_mon_ancient_stegadon_1",
						"wh2_dlc12_lzd_mon_ancient_stegadon_1"} --:vector<string>
						
	local playerFaction = cm:get_faction(cm:get_local_faction(true))
	if playerFaction:name() == "wh2_dlc09_tmb_khemri" then
		local characterList = playerFaction:character_list()
		for i = 0, characterList:num_items() - 1 do
			local currentChar = characterList:item_at(i)	
			if currentChar:character_subtype("wh2_dlc09_tmb_settra") then
				cm:remove_all_units_from_general(currentChar)
				testLOG("remove_all_units_from_general/wh2_dlc09_tmb_settra")
				local cqi = currentChar:command_queue_index()
				for k, v in pairs(TKunitstring) do 
					cm:grant_unit_to_character(cm:char_lookup_str(cqi), v)
				end
			end
		end
	elseif playerFaction:name() == "wh2_dlc09_tmb_followers_of_nagash" then
		local characterList = playerFaction:character_list()
		for i = 0, characterList:num_items() - 1 do
			local currentChar = characterList:item_at(i)	
			if currentChar:character_subtype("wh2_dlc09_tmb_arkhan") then
				cm:remove_all_units_from_general(currentChar)
				testLOG("remove_all_units_from_general/wh2_dlc09_tmb_arkhan")
				local cqi = currentChar:command_queue_index()
				for k, v in pairs(TKunitstring) do 
					cm:grant_unit_to_character(cm:char_lookup_str(cqi), v)
				end
			end
		end
	elseif playerFaction:name() == "wh2_dlc09_tmb_lybaras" then
		local characterList = playerFaction:character_list()
		for i = 0, characterList:num_items() - 1 do
			local currentChar = characterList:item_at(i)	
			if currentChar:character_subtype("wh2_dlc09_tmb_khalida") then
				cm:remove_all_units_from_general(currentChar)
				testLOG("remove_all_units_from_general/wh2_dlc09_tmb_khalida")
				local cqi = currentChar:command_queue_index()
				for k, v in pairs(TKunitstring) do 
					cm:grant_unit_to_character(cm:char_lookup_str(cqi), v)
				end
			end
		end
	elseif playerFaction:name() == "wh2_main_def_naggarond" then
		local characterList = playerFaction:character_list()
		for i = 0, characterList:num_items() - 1 do
			local currentChar = characterList:item_at(i)	
			if currentChar:character_subtype("wh2_main_def_malekith") then
				cm:remove_all_units_from_general(currentChar)
				testLOG("remove_all_units_from_general/wh2_main_def_malekith")
				local cqi = currentChar:command_queue_index()
				for k, v in pairs(DEFunitstring) do 
					cm:grant_unit_to_character(cm:char_lookup_str(cqi), v)
				end
				cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, 0, true)
			end
		end
	elseif playerFaction:name() == "wh2_main_def_cult_of_pleasure" then
		local characterList = playerFaction:character_list()
		for i = 0, characterList:num_items() - 1 do
			local currentChar = characterList:item_at(i)	
			if currentChar:character_subtype("wh2_main_def_morathi") then
				cm:remove_all_units_from_general(currentChar)
				testLOG("remove_all_units_from_general/wh2_main_def_morathi")
				local cqi = currentChar:command_queue_index()
				for k, v in pairs(DEFunitstring) do 
					cm:grant_unit_to_character(cm:char_lookup_str(cqi), v)
				end
				cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, 0, true)
			end
		end
	elseif playerFaction:name() == "wh_main_vmp_vampire_counts" then
		local characterList = playerFaction:character_list()
		for i = 0, characterList:num_items() - 1 do
			local currentChar = characterList:item_at(i)	
			if currentChar:character_subtype("vmp_mannfred_von_carstein") then
				cm:remove_all_units_from_general(currentChar)
				testLOG("remove_all_units_from_general/vmp_mannfred_von_carstein")
				local cqi = currentChar:command_queue_index()
				for k, v in pairs(VMPunitstring) do 
					cm:grant_unit_to_character(cm:char_lookup_str(cqi), v)
				end
				cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, 0, true)
			end
		end
	elseif playerFaction:name() == "wh2_dlc12_lzd_cult_of_sotek" then
		local characterList = playerFaction:character_list()
		for i = 0, characterList:num_items() - 1 do
			local currentChar = characterList:item_at(i)	
			if currentChar:character_subtype("wh2_dlc12_lzd_tehenhauin") then
				cm:remove_all_units_from_general(currentChar)
				testLOG("remove_all_units_from_general/wh2_dlc12_lzd_tehenhauin")
				local cqi = currentChar:command_queue_index()
				for k, v in pairs(LZDunitstring) do 
					cm:grant_unit_to_character(cm:char_lookup_str(cqi), v)
				end
				cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, 0, true)
			end
		end
	end
end

--v function()
local function deletePlayerSubcultureFactions()
	if cm:turn_number() == 1 then cm:force_confederation("wh2_main_hef_caledor", "wh2_main_hef_avelorn") end
	local playerFaction = cm:get_faction(cm:get_local_faction(true))
	--local factionList = playerFaction:factions_of_same_subculture()
	local factionList = cm:model():world():faction_list()
	for i = 0, factionList:num_items() - 1 do
		local faction = factionList:item_at(i)
		if faction and not faction:is_dead() and not faction:is_human() then
			if faction:name() == "wh_main_teb_tilea" or ((faction:name() == "wh2_main_hef_caledor" or faction:name() == "wh_main_emp_marienburg" or faction:name() == "wh2_main_hef_avelorn") and cm:turn_number() <= 2) then
				--if playerFaction:subculture() == faction:subculture() and cm:turn_number() == 2 then cm:force_confederation(cm:get_local_faction(true), faction:name()) end
			else		
				if cm:random_number(2, 1) == 1 then
					testLOG("deleted Faction: "..faction:name())
					local regionList = faction:region_list()
					for i = 0, regionList:num_items() - 1 do
						local currentRegion = regionList:item_at(i)
						cm:set_region_abandoned(currentRegion:name())
					end
					cm:kill_all_armies_for_faction(faction)
					--local charList = faction:character_list()
					--for i = 0, charList:num_items() - 1 do
					--	local currentChar = charList:item_at(i)
					--	if currentChar and not currentChar:is_null_interface() then 
					--		--testLOG("kill_character/character_type = "..currentChar:character_type_key()) 
					--	end
					--	--if not currentChar:character_type("colonel") then cm:kill_character(currentChar:command_queue_index(), true, false) end
					--	cm:kill_character(currentChar:command_queue_index(), true, false)
					--end
				else
					--testLOG("No luck deleting Faction: "..faction:name())
				end
			end
		end
	end
end

--v function()
local function spamLords()
	local faction = "wh_main_dwf_dwarfs"--cm:get_local_faction(true)
	local factionCA = cm:get_faction(faction)
    local x, y
    if factionCA:has_home_region() then x, y = cm:find_valid_spawn_location_for_character_from_settlement(faction, factionCA:home_region():name(), false, false, 9) end
	cm:create_force(
        faction,
        "wh_main_dwf_inf_hammerers",
        factionCA:home_region():name(),
        x,
        y,
        false,
        function(cqi)

        end
	)
end

--v function()
local function unlockLords()
    local ai_starting_generals = {
		{["id"] = "2140784160",	["forename"] = "names_name_2147358917",	["faction"] = "wh_main_dwf_dwarfs"},			-- Grombrindal
		{["id"] = "2140783606",	["forename"] = "names_name_2147345906",	["faction"] = "wh_main_grn_greenskins"},		-- Azhag the Slaughterer
		{["id"] = "2140783651",	["forename"] = "names_name_2147345320",	["faction"] = "wh_main_vmp_vampire_counts"},	-- Heinrich Kemmler
		{["id"] = "2140784146",	["forename"] = "names_name_2147358044",	["faction"] = "wh_main_vmp_vampire_counts"},	-- Helman Ghorst
		{["id"] = "2140784202",	["forename"] = "names_name_2147345124",	["faction"] = "wh_main_vmp_schwartzhafen"}		-- Isabella von Carstein
	} --:vector<map<string, string>>
	
	for i = 1, #ai_starting_generals do
		local faction = cm:get_faction(ai_starting_generals[i].faction)
		
		if not faction:is_human() then
			cm:unlock_starting_general_recruitment(ai_starting_generals[i].id, ai_starting_generals[i].faction)
		end
    end
end



-- init
--v function()
function sm0_test()
	if cm:is_new_game() then testLOG_reset() end
	cm:trigger_incident(cm:get_local_faction(true), "frosty_hef_add_influence", true)
	core:add_listener(
		"refugee_FactionTurnStart",
		"FactionTurnStart",
		true,
		function(context)
			--testLOG("sm0/faction = "..context:faction():name())
		end,
		true
	)
	expCheat()
	unitCheat()
	--unlockLords()
	--spamLords()
	core:add_listener(
		"human_FactionTurnEnd",
		"FactionTurnEnd",
		function(context)
			return context:faction():is_human()
		end,
		function(context)
			deletePlayerSubcultureFactions()
		end,
		true
	)
	core:add_listener(
		"test_FactionTurnEnd",
		"FactionTurnEnd", --FactionTurnStart
		function(context)
			return true
		end,
		function(context)
			--testLOG("Faction: "..context:faction():name().." /is_dead: "..tostring(context:faction():is_dead()))
		end,
		true
	)
	--cm:win_next_autoresolve_battle(cm:get_local_faction())
	--cm:faction_set_food_factor_value(cm:get_local_faction(true), "wh_dlc07_chivalry_events", 600)
end