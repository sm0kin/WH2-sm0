--Drunk Flamingo's log script
--All credits to Drunk Flamingo
--v function()
function mlLOG_reset()
	if not __write_output_to_logfile then
		return;
	end
	
	local logTimeStamp = os.date("%d, %m %Y %X")
	--# assume logTimeStamp: string
	
	local popLog = io.open("ml_log.txt","w+")
	popLog :write("NEW LOG ["..logTimeStamp.."] \n")
	popLog :flush()
	popLog :close()
end

--v function(text: string | number | boolean | CA_CQI)
function mlLOG(text)
	if not __write_output_to_logfile then
		return;
	end

	local logText = tostring(text)
	local logTimeStamp = os.date("%d, %m %Y %X")
	local popLog = io.open("ml_log.txt","a")
	--# assume logTimeStamp: string
	popLog :write("ML:  [".. logTimeStamp .. "]:  "..logText .. "  \n")
	popLog :flush()
	popLog :close()
end

--v function()
function mlDEBUG()
	--Vanish's PCaller
	--All credits to vanish
	--v function(func: function) --> any
	function safeCall(func)
		--out("safeCall start");
		local status, result = pcall(func)
		if not status then
			mlLOG("ERROR")
			mlLOG(tostring(result))
			mlLOG(debug.traceback());
		end
		--out("safeCall end");
		return result;
	end

	--local oldTriggerEvent = core.trigger_event;

	--v [NO_CHECK] function(...: any)
	function pack2(...) return {n=select('#', ...), ...} end
	--v [NO_CHECK] function(t: vector<WHATEVER>) --> vector<WHATEVER>
	function unpack2(t) return unpack(t, 1, t.n) end

	--v [NO_CHECK] function(f: function(), argProcessor: function()) --> function()
	function wrapFunction(f, argProcessor)
		return function(...)
			--out("start wrap ");
			local someArguments = pack2(...);
			if argProcessor then
				safeCall(function() argProcessor(someArguments) end)
			end
			local result = pack2(safeCall(function() return f(unpack2( someArguments )) end));
			--for k, v in pairs(result) do
			--    out("Result: " .. tostring(k) .. " value: " .. tostring(v));
			--end
			--out("end wrap ");
			return unpack2(result);
			end
	end

	-- function myTriggerEvent(event, ...)
	--     local someArguments = { ... }
	--     safeCall(function() oldTriggerEvent(event, unpack( someArguments )) end);
	-- end

	--v [NO_CHECK] function(fileName: string)
	function tryRequire(fileName)
		local loaded_file = loadfile(fileName);
		if not loaded_file then
			out("Failed to find mod file with name " .. fileName)
		else
			out("Found mod file with name " .. fileName)
			out("Load start")
			local local_env = getfenv(1);
			setfenv(loaded_file, local_env);
			loaded_file();
			out("Load end")
		end
	end

	--v [NO_CHECK] function(f: function(), name: string)
	function logFunctionCall(f, name)
		return function(...)
			out("function called: " .. name);
			return f(...);
		end
	end

	--v [NO_CHECK] function(object: any)
	function logAllObjectCalls(object)
		local metatable = getmetatable(object);
		for name,f in pairs(getmetatable(object)) do
			if is_function(f) then
				out("Found " .. name);
				if name == "Id" or name == "Parent" or name == "Find" or name == "Position" or name == "CurrentState"  or name == "Visible"  or name == "Priority" or "Bounds" then
					--Skip
				else
					metatable[name] = logFunctionCall(f, name);
				end
			end
			if name == "__index" and not is_function(f) then
				for indexname,indexf in pairs(f) do
					out("Found in index " .. indexname);
					if is_function(indexf) then
						f[indexname] = logFunctionCall(indexf, indexname);
					end
				end
				out("Index end");
			end
		end
	end

	-- logAllObjectCalls(core);
	-- logAllObjectCalls(cm);
	-- logAllObjectCalls(game_interface);

	core.trigger_event = wrapFunction(
		core.trigger_event,
		function(ab)
			--out("trigger_event")
			--for i, v in pairs(ab) do
			--    out("i: " .. tostring(i) .. " v: " .. tostring(v))
			--end
			--out("Trigger event: " .. ab[1])
		end
	);

	cm.check_callbacks = wrapFunction(
		cm.check_callbacks,
		function(ab)
			--out("check_callbacks")
			--for i, v in pairs(ab) do
			--    out("i: " .. tostring(i) .. " v: " .. tostring(v))
			--end
		end
	)

	local currentAddListener = core.add_listener;
	--v [NO_CHECK] function(core: any, listenerName: any, eventName: any, conditionFunc: (function(context: WHATEVER?) --> boolean) | boolean, listenerFunc: function(context: WHATEVER?), persistent: any)
	function myAddListener(core, listenerName, eventName, conditionFunc, listenerFunc, persistent)
		local wrappedCondition = nil;
		if is_function(conditionFunc) then
			--wrappedCondition =  wrapFunction(conditionFunc, function(arg) out("Callback condition called: " .. listenerName .. ", for event: " .. eventName); end);
			wrappedCondition =  wrapFunction(conditionFunc);
		else
			wrappedCondition = conditionFunc;
		end
		currentAddListener(
			core, listenerName, eventName, wrappedCondition, wrapFunction(listenerFunc), persistent
			--core, listenerName, eventName, wrappedCondition, wrapFunction(listenerFunc, function(arg) out("Callback called: " .. listenerName .. ", for event: " .. eventName); end), persistent
		)
	end
	core.add_listener = myAddListener;
end

mlDEBUG();

local loreButton_charPanel = nil --:BUTTON
local loreButton_preBattle = nil --:CA_UIC
local loreButton_unitsPanel = nil --:BUTTON
local spellBrowserButton = nil --:CA_UIC
local optionButton = nil --:CA_UIC
local resetButton = nil --:CA_UIC
local frameButtonContainer = nil --:CONTAINER
local returnButton = nil --:BUTTON
local loreFrame = nil --:FRAME
local spellButtonContainer = nil --:CONTAINER
local loreButtonContainer = nil --:CONTAINER
local spellSlotButtonContainer = nil --:CONTAINER
local homeIconPath = "ui/icon_home_small2.png";
local bookIconPath = "ui/icon_lorebook2.png";
local browserIconPath = "ui/icon_spell_browser2.png";
local optionsIconPath = "ui/icon_options2.png";
local resetIconPath = "ui/icon_stats_reset_small2.png";
local shuffleIconPath = "ui/icon_swap_small2.png"
local playerFaction = cm:get_faction(cm:get_local_faction(true));
if string.find(playerFaction:name(), "wh_") then
	bookIconPath = "ui/icon_lorebook.png";
	browserIconPath = "ui/icon_spell_browser.png";
	optionsIconPath = "ui/icon_options.png";
	resetIconPath = "ui/icon_stats_reset_small.png";
	shuffleIconPath = "ui/icon_swap_small.png"
end
local ml_tables --:ml_tables
local spellSlotButtons = {} --:vector<TEXT_BUTTON>
local spellSlotSelected = nil --:string
local pX --:number
local pY --:number
local dummyButton = TextButton.new("dummyButton", core:get_ui_root(), "TEXT", "dummy");
local dummyButtonX, dummyButtonY = dummyButton:Bounds();
dummyButton:Delete();
local file_str = cm:get_game_interface():filesystem_lookup("/script/ml_tables", "ml*")
local createSpellSlotButtonContainer --:function(char: CA_CHAR, spellSlots: vector<string>)

--v function(char: CA_CHAR) --> bool
function is_mlChar(char)
	if not char:is_null_interface() and string.find(file_str, char:character_subtype_key()) then
		return true;
	else
		return false;
	end
end

--v function(char: CA_CHAR) --> WHATEVER
function ml_force_require(char)
	if is_mlChar(char) then
		local file = "ml_tables/ml_"..char:character_subtype_key();
		package.loaded[file] = nil;
		return require(file);
	else
		return nil;
	end
end

--v function(char: CA_CHAR)
function resetSaveTable(char)
	local spellSlots = {"Spell Slot - 1 -", "Spell Slot - 2 -", "Spell Slot - 3 -", "Spell Slot - 4 -", "Spell Slot - 5 -", "Spell Slot - 6 -"} --:vector<string>
	local saveString = "return {"..cm:process_table_save(spellSlots).."}";
	cm:set_saved_value("ml_"..char:get_forename().." "..char:get_surname().."|"..tostring(char:cqi()), saveString);
end

--v function() --> CA_CHAR					
function getSelectedCharacter()
	local selectedCharacterCqi = cm:get_campaign_ui_manager():get_char_selected_cqi();
	return cm:get_character_by_cqi(selectedCharacterCqi);
end

--v function(textObj: CA_UIC) --> CA_CHAR
function getCharByStateText(textObj)
	local char = nil --:CA_CHAR
	if textObj then
		local text = textObj:GetStateText();
		local characterList = playerFaction:character_list();
		for i = 0, characterList:num_items() - 1 do
			local currentChar = characterList:item_at(i);
			charStr = effect.get_localised_string(currentChar:get_forename()).." "..effect.get_localised_string(currentChar:get_surname());
			if text == charStr then	
				char = currentChar;
			end
		end
	end
	return char;
end

--v function(char: CA_CHAR) --> bool
function is_agentSelected(char)
	local units = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "units");
	--local character_list = char:military_force():character_list();
	local is_selected = false;
	for i = 0, units:ChildCount() - 1 do
		local unit = UIComponent(units:Find(i));
		if string.find(unit:Id(), "Agent") and unit:CurrentState() == "Selected" then
			is_selected = true;
			--for i = 0, character_list:num_items() - 1 do
				--
			--end
		end
	end
	return is_selected;
end

--v function() --> CA_CHAR
function getmlChar()
	local char = nil --:CA_CHAR
	local pb = cm:model():pending_battle();
	if not pb:is_active() then
		selectedChar = getSelectedCharacter();
		if selectedChar and is_mlChar(selectedChar) then
			char = selectedChar;
		end
		if not char then
			local focusButton = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "header", "button_focus", "dy_txt"); 
			local charByUnitPanel = getCharByStateText(focusButton);
			local namePanel = find_uicomponent(core:get_ui_root(), "character_details_panel", "character_name");
			local charByCharPanel = getCharByStateText(namePanel);
			if charByUnitPanel and is_mlChar(charByUnitPanel) then
				char = charByUnitPanel;
			elseif not char and charByCharPanel and is_mlChar(charByCharPanel) then
				char = charByCharPanel;
			end
		end
	elseif not char and is_mlChar(pb:attacker()) and pb:attacker():faction():is_human() then
		char = pb:attacker();
		if not is_mlChar(char) and pb:secondary_attackers():num_items() >= 1 then 
			local attackers = pb:secondary_attackers();
			for i = 0, attackers:num_items() - 1 do
				if attackers:item_at(i):faction():is_human() and is_mlChar(attackers:item_at(i)) then
					char = attackers:item_at(i);
				end
			end
		end
	elseif not char and is_mlChar(pb:defender()) and pb:defender():faction():is_human() then
		char = pb:defender();
		if not is_mlChar(char) and pb:secondary_defenders():num_items() >= 1 then
			local defenders = pb:secondary_defenders();
			for i = 0, defenders:num_items() - 1 do
				if defenders:item_at(i):faction():is_human() and is_mlChar(defenders:item_at(i)) then
					char = defenders:item_at(i);
				end
			end
		end
	end
	return char;
end

--v function()
function re_init()
	--loreButtonContainer = nil;
	--spellButtonContainer = nil;
	--spellSlotButtonContainer = nil;
	spellSlotSelected = nil;
	--optionButton = nil;
	--spellBrowserButton = nil;
	--resetButton = nil;
	returnButton = nil;
	loreFrame = nil;
end

--v function(char: CA_CHAR)
function updateSkillTable(char)
	if ml_tables then
		for skill, _ in pairs(ml_tables.has_skills) do
			if char:has_skill(skill) then
				ml_tables.has_skills[skill] = true;
			else
				ml_tables.has_skills[skill] = false;
			end
		end
	end
end

--v function(table: table, element: any) --> bool
function tableContains(table, element)
	for _, value in pairs(table) do
		if value == element then
		return true
		end
	end
	return false
end

--v function(char: CA_CHAR, spellSlots: vector<string>)					
function applySpellDisableEffect(char, spellSlots)
	local savedOption = cm:get_saved_value("ml_"..char:get_forename().." "..char:get_surname().."|"..tostring(char:cqi()).."_".."option")
	local charCqi = char:cqi();
	ml_tables = ml_force_require(char);
	if ml_tables then
		if savedOption == "Spells for free" and not char:military_force():has_effect_bundle(ml_tables.enableAllBundle) then
			cm:apply_effect_bundle_to_characters_force(ml_tables.enableAllBundle, charCqi, -1, false);
		elseif savedOption ~= "Spells for free" and char:military_force():has_effect_bundle(ml_tables.enableAllBundle) then
			cm:remove_effect_bundle_from_characters_force(ml_tables.enableAllBundle, charCqi);
		end
		for _, effectBundle in pairs(ml_tables.effectBundles) do
			if not char:military_force():has_effect_bundle(effectBundle) then
				cm:apply_effect_bundle_to_characters_force(effectBundle, charCqi, -1, false);
			end
		end
		for _, spell in ipairs(spellSlots) do 
			if ml_tables.effectBundles[spell] and char:military_force():has_effect_bundle(ml_tables.effectBundles[spell]) then
				cm:remove_effect_bundle_from_characters_force(ml_tables.effectBundles[spell], charCqi);
			end
		end
	end
end

--v [NO_CHECK] function(spellName: any, char: CA_CHAR) --> vector<string>
function updateSaveTable(spellName, char)
	local savedValue = cm:get_saved_value("ml_"..char:get_forename().." "..char:get_surname().."|"..tostring(char:cqi()));
	if not savedValue then
		resetSaveTable(char);
	end
	local spellSlots = loadstring(cm:get_saved_value("ml_"..char:get_forename().." "..char:get_surname().."|"..tostring(char:cqi())))();
	if spellName then
		for i, spellSlot in ipairs(spellSlots) do
			if  "Spell Slot - "..i.." -" == spellSlotSelected then
				spellSlots[i] = spellName;
				local saveString = "return {"..cm:process_table_save(spellSlots).."}";
				cm:set_saved_value("ml_"..char:get_forename().." "..char:get_surname().."|"..tostring(char:cqi()), saveString);
			end
		end
	end
	return spellSlots;
end

--v function(tbl: map<number | integer, WHATEVER>) --> map<number | integer, WHATEVER>
function shuffle(tbl)
	for i = #tbl, 2, -1 do
		local j = cm:random_number(i);
		tbl[i], tbl[j] = tbl[j], tbl[i]
	end
	return tbl;
end

--v function(char: CA_CHAR)
function randomSpells(char)
	resetSaveTable(char);
	local spellSlots = updateSaveTable(false, char);
	local skillPool = {};
	ml_tables = ml_force_require(char);
	updateSkillTable(char);
	local savedOption = cm:get_saved_value("ml_"..char:get_forename().." "..char:get_surname().."|"..tostring(char:cqi()).."_".."option");
	if savedOption == "Spells for free" then
		for skill, _ in pairs(ml_tables.has_skills) do
			table.insert(skillPool, skill);
		end
	else
		for skill, has_skill in pairs(ml_tables.has_skills) do
			if has_skill then
				table.insert(skillPool, skill);
			end
		end
	end
	local lorePool = {} 
	--#assume skillPool :map<number, string>
	if #skillPool > #spellSlots then
		skillPool = shuffle(skillPool);
	end
	if ml_tables.default_rule == "Modified TT 8th edition - Teclis" then
		local skillAllowed = {["Lore of High Magic"]= true, ["Lore of Beasts"] = true, ["Lore of Light"] = true, ["Lore of Life"] = true, ["Lore of Heavens"] = true, ["Lore of Fire"] = true,
							["Lore of Metal"] = true, ["Lore of Shadows"] = true, ["Lore of Death"] = true} --:map<string, bool>
		for i, skill in pairs(skillPool) do
			if skillAllowed[ml_tables.loreName[skill]] then
				skillAllowed[ml_tables.loreName[skill]] = false;
				table.insert(lorePool, skill)	
			end
		end
		if #lorePool < #spellSlots then
			for i, skill in pairs(skillPool) do
				if ml_tables.loreName[skill] == "Lore of High Magic" and #lorePool < #spellSlots and not tableContains(lorePool, skill) then
					table.insert(lorePool, skill)	
				end
			end
		end
		skillPool = lorePool;
	end
	for i, spellSlot in ipairs(spellSlots) do
		spellSlots[i] = ml_tables.skillnames[skillPool[i]];
		spellSlotSelected = "Spell Slot - "..i.." -";
		spellSlots = updateSaveTable(spellSlots[i], char);
		spellSlotSelected = nil;
	end
	applySpellDisableEffect(char, spellSlots);
end	

--v [NO_CHECK] function(lore: string, char: CA_CHAR)
function createSpellButtonContainer(lore, char)
	local loreTable = ml_tables.lores[lore] --:map<string, string>
	updateSkillTable(char);
	local spellButtonList = ListView.new("SpellButtonList", loreFrame, "VERTICAL");
	spellButtonList:Resize(pX/2 - 18, pY - dummyButtonY/2);
	spellButtonContainer = Container.new(FlowLayout.VERTICAL);	
	local spellButtons = {} --:vector<TEXT_BUTTON>
	local spellSlots = updateSaveTable(false, char);
	for skill, spell in pairs(loreTable) do
		local spellButton = TextButton.new(spell, loreFrame, "TEXT", spell);
		spellButton:SetState("hover");
		spellButton.uic:SetTooltipText("Select "..spell.." to replace "..spellSlots[tonumber(string.match(spellSlotSelected, "%d"))]..".");	
		spellButton:SetState("active");
		for _, spellSlot in ipairs(spellSlots) do
			if spellSlot == spell then
				spellButton:SetDisabled(true);
				spellButton.uic:SetTooltipText("This spell has already been selected.");	
			end
		end
		local savedOption = cm:get_saved_value("ml_"..char:get_forename().." "..char:get_surname().."|"..tostring(char:cqi()).."_".."option")
		if savedOption ~= "Spells for free" and not ml_tables.has_skills[skill] then
			spellButton:SetDisabled(true);
			local reqTooltip = "Required Skill: "..effect.get_localised_string("character_skills_localised_name_"..skill);
			spellButton.uic:SetTooltipText(reqTooltip);	
		end
		if ml_tables.default_rule == "Modified TT 8th edition - Teclis" and not tableContains(loreTable, spellSlots[tonumber(string.match(spellSlotSelected, "%d"))]) and lore ~= "Lore of High Magic" then
			for _, spell in ipairs(spellSlots) do
				if tableContains(loreTable, spell) then
					spellButton:SetDisabled(true);
					spellButton.uic:SetTooltipText("You can only choose one spell from the "..lore..".");	
				end
			end
		end
		table.insert(spellButtons, spellButton);
		spellButton:RegisterForClick(
			function(context)
				local spellSlots = updateSaveTable(spellButton.name, char);
				createSpellSlotButtonContainer(char, spellSlots);
				applySpellDisableEffect(char, spellSlots)
				spellSlotSelected = nil;
			end
		)
		spellButtonList:AddComponent(spellButton);
	end
	spellButtonContainer:AddComponent(spellButtonList);
	spellButtonContainer:PositionRelativeTo(loreFrame, pX/2 + 35, dummyButtonY/4);
	loreFrame:AddComponent(spellButtonContainer);
end

--v function(buttons: vector<TEXT_BUTTON>, char: CA_CHAR)
function setupSingleSelectedButtonGroup(buttons, char)
	for _, button in ipairs(buttons) do
		button:SetState("active");
		button:RegisterForClick(
			function(context)
				for _, otherButton in ipairs(buttons) do
					if button.name == otherButton.name then
						otherButton:SetState("selected_hover");
						otherButton.uic:SetTooltipText("Select your prefered spell of the "..button.name..".");
					else
						otherButton:SetState("hover");
						otherButton.uic:SetTooltipText("Select the Lore of Magic you want to pick a spell from.");
						otherButton:SetState("active");
					end
				end
				if spellButtonContainer then
					spellButtonContainer:Clear();
				end
				createSpellButtonContainer(button.name, char);
			end
		);
	end
end

--v function(char: CA_CHAR)
function createLoreButtonContainer(char)
	spellSlotButtonContainer:Clear();
	local loreButtonList = ListView.new("LoreButtonList", loreFrame, "VERTICAL");
	loreButtonList:Resize(pX/2 - 9, pY - dummyButtonY/2); -- width vslider 18
	loreButtonContainer = Container.new(FlowLayout.VERTICAL);
	local loreButtons = {} --:vector<TEXT_BUTTON>
	local loreEnable = {};
	for lore, _ in pairs(ml_tables.lores) do
		local loreButton = TextButton.new(lore, loreFrame, "TEXT_TOGGLE", lore);
		table.insert(loreButtons, loreButton);
		loreButtonList:AddComponent(loreButton);
	end	
	setupSingleSelectedButtonGroup(loreButtons, char);
	loreButtonContainer:AddComponent(loreButtonList);
	loreButtonContainer:PositionRelativeTo(loreFrame, 22, dummyButtonY/4);
	loreFrame:AddComponent(loreButtonContainer);
end

--v function(char: CA_CHAR)
function createReturnButton(char)
	returnButton = Button.new("returnButton", loreFrame, "CIRCULAR", homeIconPath); 
	local closeButton = find_uicomponent(core:get_ui_root(), "Lore of MagicCloseButton");
	local closeButtonX, closeButtonY = closeButton:Position();
	closeButton:MoveTo(closeButtonX + closeButton:Width()/2, closeButtonY);
	returnButton:PositionRelativeTo(closeButton, - closeButton:Width(), 0);
	returnButton:SetState("hover");
	returnButton.uic:SetTooltipText("Return to Spell Slot List");			
	returnButton:SetState("active");
	returnButton:RegisterForClick(
		function(context)
			if spellButtonContainer then spellButtonContainer:Clear(); end
			if loreButtonContainer then loreButtonContainer:Clear(); end
			if spellSlotButtonContainer then spellSlotButtonContainer:Clear(); end
			createSpellSlotButtonContainer(char, updateSaveTable(false, char));
		end
	)
	frameButtonContainer:AddComponent(returnButton);
end	

createSpellSlotButtonContainer = function(char, spellSlots)
	if returnButton then
		frameButtonContainer:Clear();
		returnButton = nil;
		local closeButton = find_uicomponent(core:get_ui_root(), "Lore of MagicCloseButton");
		local closeButtonX, closeButtonY = closeButton:Position();
		closeButton:MoveTo(closeButtonX - closeButton:Width()/2, closeButtonY)
	end
	if loreButtonContainer then loreButtonContainer:Clear(); end
	if spellButtonContainer then spellButtonContainer:Clear(); end
	local spellSlotButtonList = ListView.new("SpellSlotButtonList", loreFrame, "VERTICAL");
	spellSlotButtonList:Resize(dummyButtonX, pY - dummyButtonY/2); --(pX/2 - 13, pY - 40);
	spellSlotButtonContainer = Container.new(FlowLayout.VERTICAL);
	for i, spellSlot in ipairs(spellSlots) do
		local spellSlotButton = TextButton.new("Spell Slot - "..i.." -", loreFrame, "TEXT", spellSlot);
		table.insert(spellSlotButtons, spellSlotButton);
		spellSlotButton:RegisterForClick(
			function(context)
				spellSlotSelected = spellSlotButton.name;
				createLoreButtonContainer(char);
				createReturnButton(char);
			end
		)
		spellSlotButtonList:AddComponent(spellSlotButton);
	end
	spellSlotButtonContainer:AddComponent(spellSlotButtonList);
	Util.centreComponentOnComponent(spellSlotButtonContainer, loreFrame);
	loreFrame:AddComponent(spellSlotButtonContainer);
end

--v function()
function editSpellBrowserUI()
	local spell_browser = find_uicomponent(core:get_ui_root(), "spell_browser");
	if loreFrame then
		loreFrame:PositionRelativeTo(spell_browser, spell_browser:Width(), spell_browser:Height() - loreFrame:Height() + 53);
	end
	local char = getmlChar();
	ml_tables = ml_force_require(char);
	if char then
		local spellSlots = updateSaveTable(false, char);
		for spellName, button in pairs(ml_tables.spells) do
			local compositeSpell = find_uicomponent(core:get_ui_root(), "spell_browser", "composite_lore_parent", "composite_spell_list", button);
			if not tableContains(spellSlots, spellName) then
				Util.delete(compositeSpell);
			end
		end
	end
end

--v function()
function createSpellBrowserButton()
	spellBrowserButton = Util.createComponent("spellBrowserButton", loreFrame.uic, "ui/templates/round_small_button");
	spellBrowserButton:Resize(28, 28);
	local posFrameX, posFrameY = loreFrame:Position();
	local offsetX, offsetY = 10, 10;
	spellBrowserButton:MoveTo(posFrameX + offsetX, posFrameY + offsetY);
	spellBrowserButton:SetImage(browserIconPath);
	spellBrowserButton:SetState("hover");
	spellBrowserButton:SetTooltipText("Spell Browser");
	spellBrowserButton:PropagatePriority(100);
	spellBrowserButton:SetState("active");
	local button_spell_browser = find_uicomponent(core:get_ui_root(), "button_spell_browser");
	if not button_spell_browser then
		spellBrowserButton:SetDisabled(true);
	else
		spellBrowserButton:SetDisabled(false);
	end
	Util.registerForClick(spellBrowserButton, "ml_spellBrowserButtonListener",
		function(context)
			button_spell_browser:SimulateLClick();
		end
	)
	loreFrame:AddComponent(spellBrowserButton);
end

--v function(char: CA_CHAR)
function createOptionsFrame(char)
	local closeButton = find_uicomponent(core:get_ui_root(), "Lore of MagicCloseButton");
	if closeButton then closeButton:SetVisible(false); end
	if returnButton then returnButton:SetVisible(false); end
	local optionFrame = find_uicomponent(core:get_ui_root(), "Options - Rules");
	--# assume optionFrame: FRAME
	if optionFrame then
		return;
	end
	optionFrame = Frame.new("Options - Rules");
	optionFrame.uic:PropagatePriority(100);
	loreFrame.uic:Adopt(optionFrame.uic:Address());
	optionFrame:AddCloseButton(
		function()
			resetSaveTable(char);
			local slotTable = updateSaveTable(false, char);
			applySpellDisableEffect(char, slotTable);
			if spellButtonContainer then spellButtonContainer:Clear(); end
			if loreButtonContainer then loreButtonContainer:Clear(); end
			if spellSlotButtonContainer then spellSlotButtonContainer:Clear(); end
			if frameButtonContainer then frameButtonContainer:Clear(); end
			if loreFrame then createSpellSlotButtonContainer(char, slotTable); end
			if closeButton then closeButton:SetVisible(true); end
			if returnButton then returnButton:SetVisible(true); end
		end
	);
	local optionButtons = {} --:vector<TEXT_BUTTON>
	local optionFrameButtonContainer = Container.new(FlowLayout.VERTICAL);
	optionFrame:AddComponent(optionFrameButtonContainer);
	local optionButtonList = ListView.new("optionButtonList", optionFrame, "VERTICAL");
	optionButtonList:Resize(dummyButtonX, pY - dummyButtonY/2);
	optionFrameButtonContainer:AddComponent(optionButtonList);
	Util.centreComponentOnComponent(optionFrameButtonContainer, optionFrame);
	local defaultButton = TextButton.new("Skill - based", optionFrame, "TEXT_TOGGLE", "Skill - based");
	defaultButton:SetState("hover");
	defaultButton.uic:SetTooltipText("Spells are been made available by their respective skill.");
	defaultButton:SetState("active");
	table.insert(optionButtons, defaultButton);
	optionButtonList:AddComponent(defaultButton);
	local freeSpellsButton = TextButton.new("Spells for free", optionFrame, "TEXT_TOGGLE", "Spells for free");
	freeSpellsButton:SetState("hover");
	freeSpellsButton.uic:SetTooltipText("All spells are available from the start.");
	freeSpellsButton:SetState("active");
	table.insert(optionButtons, freeSpellsButton);
	optionButtonList:AddComponent(freeSpellsButton);
	local savedOption = cm:get_saved_value("ml_"..char:get_forename().." "..char:get_surname().."|"..tostring(char:cqi()).."_".."option")
	local savedButton = find_uicomponent(core:get_ui_root(), savedOption);
	for _, button in ipairs(optionButtons) do
		button:SetState("active");
		button:RegisterForClick(
			function(context)
				for _, otherButton in ipairs(optionButtons) do
					if button.name == otherButton.name then
						otherButton:SetState("selected_hover");
						--otherButton.uic:SetTooltipText("");
					else
						otherButton:SetState("active");
					end
				end
				cm:set_saved_value("ml_"..char:get_forename().." "..char:get_surname().."|"..tostring(char:cqi()).."_".."option", button.name);
			end
		);
	end
	savedButton:SetState("selected");
	Util.centreComponentOnScreen(optionFrame);
	local spell_browser = find_uicomponent(core:get_ui_root(), "spell_browser");
	if spell_browser then
		loreFrame:PositionRelativeTo(spell_browser, spell_browser:Width(), spell_browser:Height() - loreFrame:Height() + 53);
	end
	loreFrame.uic:RemoveTopMost();
	optionFrame.uic:RegisterTopMost();
end

--v function(char: CA_CHAR)
function createOptionButton(char)
	optionButton = Util.createComponent("optionButton", loreFrame.uic, "ui/templates/round_small_button");
	optionButton:Resize(28, 28);
	local posFrameX, posFrameY = loreFrame:Position();
	local sizeFrameX, sizeFrameY = loreFrame:Bounds(); 
	local offsetX, offsetY = 10, 10;
	optionButton:MoveTo(posFrameX + sizeFrameX - (offsetX + optionButton:Width()), posFrameY + offsetY);
	optionButton:SetImage(optionsIconPath);
	optionButton:SetState("hover");
	optionButton:SetTooltipText("Options");
	optionButton:PropagatePriority(100);
	optionButton:SetState("active");
	Util.registerForClick(optionButton, "ml_optionButtonListener",
		function(context)
			createOptionsFrame(char);
		end
	)
	loreFrame:AddComponent(optionButton);
end

--v function(char: CA_CHAR)
function createResetButton(char)
	resetButton = Util.createComponent("resetButton", loreFrame.uic, "ui/templates/round_small_button");
	resetButton:Resize(28, 28);
	local posFrameX, posFrameY = loreFrame:Position();
	local sizeFrameX, sizeFrameY = loreFrame:Bounds(); 
	local offsetX, offsetY = 10, 10;
	resetButton:MoveTo(posFrameX + sizeFrameX - (offsetX + 2*resetButton:Width()), posFrameY + offsetY);
	resetButton:SetImage(resetIconPath);
	resetButton:SetState("hover");
	resetButton:SetTooltipText("Reset");
	resetButton:PropagatePriority(100);
	resetButton:SetState("active");
	Util.registerForClick(resetButton, "ml_resetButtonListener",
		function(context)
			resetSaveTable(char);
			local slotTable = updateSaveTable(false, char);
			applySpellDisableEffect(char, slotTable);
			if spellButtonContainer then spellButtonContainer:Clear(); end
			if loreButtonContainer then loreButtonContainer:Clear(); end
			if spellSlotButtonContainer then spellSlotButtonContainer:Clear(); end
			if frameButtonContainer then frameButtonContainer:Clear(); end
			createSpellSlotButtonContainer(char, slotTable);
		end
	)
	loreFrame:AddComponent(resetButton);
end

--v function(char: CA_CHAR)
	function createShuffleButton(char)
		shuffleButton = Util.createComponent("shuffleButton", loreFrame.uic, "ui/templates/round_small_button");
		shuffleButton:Resize(28, 28);
		local posFrameX, posFrameY = loreFrame:Position();
		local sizeFrameX, sizeFrameY = loreFrame:Bounds(); 
		local offsetX, offsetY = 10, 10;
		shuffleButton:MoveTo(posFrameX + sizeFrameX - (offsetX + 3*shuffleButton:Width()), posFrameY + offsetY);
		shuffleButton:SetImage(shuffleIconPath);
		shuffleButton:SetState("hover");
		shuffleButton:SetTooltipText("Shuffle");
		shuffleButton:PropagatePriority(100);
		shuffleButton:SetState("active");
		Util.registerForClick(shuffleButton, "ml_shuffleButtonListener",
			function(context)
				randomSpells(char);
				local slotTable = updateSaveTable(false, char);
				if spellButtonContainer then spellButtonContainer:Clear(); end
				if loreButtonContainer then loreButtonContainer:Clear(); end
				if spellSlotButtonContainer then spellSlotButtonContainer:Clear(); end
				if frameButtonContainer then frameButtonContainer:Clear(); end
				createSpellSlotButtonContainer(char, slotTable);
			end
		)
		loreFrame:AddComponent(shuffleButton);
	end

--v function()
function createLoreUI()
	if loreFrame then
		return;
	end
	loreFrame = Frame.new("Lore of Magic");

	local spell_browser = find_uicomponent(core:get_ui_root(), "spell_browser");
	loreFrame.uic:PropagatePriority(100);
	loreFrame:AddCloseButton(
		function()
			core:remove_listener("ml_optionButtonListener");
			core:remove_listener("ml_spellBrowserButtonListener");
			core:remove_listener("ml_resetButtonListener");
			core:remove_listener("ml_shuffleButtonListener");
			re_init();
		end, true
	);
	local closeButton = find_uicomponent(core:get_ui_root(), "Lore of MagicCloseButton");
	closeButton:SetState("hover");
	closeButton:SetTooltipText("Close Lore of Magic");			
	closeButton:SetState("active");
	frameButtonContainer = Container.new(FlowLayout.HORIZONTAL);
	loreFrame:AddComponent(frameButtonContainer);
	local parchment = find_uicomponent(core:get_ui_root(), "Lore of Magic", "parchment");
	pX, pY = parchment:Bounds();
	Util.centreComponentOnScreen(loreFrame);
	if spell_browser then
		loreFrame:PositionRelativeTo(spell_browser, spell_browser:Width(), spell_browser:Height() - loreFrame:Height() + 53);
	end
	local char = getmlChar();
	ml_tables = ml_force_require(char);
	updateSkillTable(char);
	local spellSlots = updateSaveTable(false, char);
	createSpellBrowserButton();
	createOptionButton(char);
	createResetButton(char);
	createShuffleButton(char);
	createSpellSlotButtonContainer(char, spellSlots);
	--loreFrame.uic:SetMoveable(true);
	loreFrame.uic:RegisterTopMost();
end

--v function()
function updateButtonVisibility_charPanel()
	local char = getmlChar()
	if char and not is_agentSelected(char) then
		loreButton_charPanel:SetVisible(true);
	else
		loreButton_charPanel:SetVisible(false);
	end
end

--v function()
function createloreButton_charPanel()
	--cm:callback(
	--	function(context)
			if loreButton_charPanel == nil then
				loreButton_charPanel = Button.new("loreButton_charPanel", find_uicomponent(core:get_ui_root(), "character_details_panel", "background", "bottom_buttons"), "SQUARE", bookIconPath);
				local characterdetailspanel = find_uicomponent(core:get_ui_root(), "character_details_panel");
				local referenceButton = find_uicomponent(characterdetailspanel, "button_replace_general");
				loreButton_charPanel:Resize(referenceButton:Width(), referenceButton:Height());
				loreButton_charPanel:PositionRelativeTo(referenceButton, -loreButton_charPanel:Width() - 1, 0);
				loreButton_charPanel:SetState("hover");
				loreButton_charPanel.uic:SetTooltipText("Lore of Magic");			
				loreButton_charPanel:SetState("active");
				loreButton_charPanel:RegisterForClick(
					function(context)
						createLoreUI();
						spellBrowserButton:SetDisabled(true);
						spellBrowserButton:SetOpacity(50);
						--spellBrowserButton:SetTooltipText("Locked by c++");	
					end
				)
			end
			updateButtonVisibility_charPanel();			
	--	end, 0, "createloreButton_charPanel"
	--);
end

--v function(battle_type: BATTLE_TYPE)
function createloreButton_preBattle(battle_type)
	local buttonParent = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "list");
	loreButton_preBattle = Util.createComponent("loreButton_preBattle", buttonParent, "ui/templates/round_small_button");
	--cm:callback(
	--	function(context)
			local posFrameX, posFrameY = buttonParent:Position();
			local sizeFrameX, sizeFrameY = buttonParent:Bounds(); 
			local referenceButton = find_uicomponent(buttonParent, "battle_information_panel", "button_holder", "button_info");
			local posReferenceButtonX, posReferenceButtonY = referenceButton:Position();
			local offsetX = (posFrameX + sizeFrameX) - (posReferenceButtonX + referenceButton:Width())
			loreButton_preBattle:MoveTo(posFrameX + offsetX, posReferenceButtonY);
			loreButton_preBattle:SetImage(bookIconPath);
			loreButton_preBattle:SetState("hover");
			loreButton_preBattle:SetTooltipText("Lore of Magic");
			loreButton_preBattle:PropagatePriority(100);
			loreButton_preBattle:SetState("active");
			if battle_type == "settlement_standard" or battle_type == "settlement_unfortified" then 
				referenceButton = find_uicomponent(buttonParent, "siege_information_panel", "button_holder", "button_info");
			elseif battle_type == "ambush" or battle_type == "land_ambush" then
				loreButton_preBattle:SetDisabled(true);
				loreButton_preBattle:SetTooltipText("This is not the time...");
				loreButton_preBattle:SetOpacity(50);
			end
	--		end, 0, "positionloreButton_preBattle"
	--);
	Util.registerForClick(loreButton_preBattle, "loreButton_preBattle_Listener",
		function(context)
			createLoreUI();
			spellBrowserButton:SetDisabled(true);
			spellBrowserButton:SetOpacity(50);
			--spellBrowserButton:SetTooltipText("Locked by c++");	
		end
	)
end

--v function()
function createloreButton_unitsPanel()
	loreButton_unitsPanel = Button.new("loreButton_unitsPanel", find_uicomponent(core:get_ui_root(), "layout", "hud_center_docker", "hud_center", "small_bar", "button_group_army"), "SQUARE", bookIconPath);
	--cm:callback(
	--	function(context)
			local unitsPanel = find_uicomponent(core:get_ui_root(), "button_group_army");
			local renownButton = find_uicomponent(unitsPanel, "button_renown"); 
			local recruitButton = find_uicomponent(unitsPanel, "button_recruitment");
			loreButton_unitsPanel:Resize(renownButton:Width(), renownButton:Height());
			if renownButton:Visible() then
				loreButton_unitsPanel:PositionRelativeTo(renownButton, loreButton_unitsPanel:Width() + 4, 0);
			else
				loreButton_unitsPanel:PositionRelativeTo(recruitButton, loreButton_unitsPanel:Width() + 4, 0);
			end
			loreButton_unitsPanel:SetState("hover");
			loreButton_unitsPanel.uic:SetTooltipText("Lore of Magic");
			loreButton_unitsPanel:SetState("active");
	--	end, 0, "positionloreButton_unitsPanel"
	--);
	loreButton_unitsPanel:RegisterForClick(
		function(context)
			createLoreUI();
		end
	)
end

--v function()
function deleteLoreFrame()
	if loreFrame then
		loreFrame:Delete();
		core:remove_listener("ml_optionButtonListener");
		core:remove_listener("ml_spellBrowserButtonListener");
		core:remove_listener("ml_resetButtonListener");
		core:remove_listener("ml_shuffleButtonListener");
	end
	re_init();
end

--v function(char: CA_CHAR)
function setupInnateSpells(char)
	local savedOption = cm:get_saved_value("ml_"..char:get_forename().." "..char:get_surname().."|"..tostring(char:cqi()).."_".."option")
	ml_tables = ml_force_require(char);
	if savedOption ~= "Spells for free" then
		local spellSlots = updateSaveTable(false, char);
		local innateSpells = {}
		updateSkillTable(char);
		for skill, has_skill in pairs(ml_tables.has_skills) do
			if has_skill then
				table.insert(innateSpells, ml_tables.skillnames[skill]);
			end
		end
		for _, innateSpell in ipairs(innateSpells) do
			if not tableContains(spellSlots, innateSpell) then
				for i, spellSlot in ipairs(spellSlots) do
					if string.find(spellSlot, "Spell Slot") then
						spellSlotSelected = "Spell Slot - "..i.." -";
						spellSlots = updateSaveTable(innateSpell, char);
						applySpellDisableEffect(char, spellSlots)
						spellSlotSelected = nil;
						break;
					end
				end
			end
		end
	end
end

--v function(char: CA_CHAR)
function setupSavedOptions(char)
	local savedRule = cm:get_saved_value("ml_"..char:get_forename().." "..char:get_surname().."|"..tostring(char:cqi()).."_".."rule")
	if not savedRule then
		cm:set_saved_value("ml_"..char:get_forename().." "..char:get_surname().."|"..tostring(char:cqi()).."_".."rule", ml_tables.default_rule);
	end
	local savedOption = cm:get_saved_value("ml_"..char:get_forename().." "..char:get_surname().."|"..tostring(char:cqi()).."_".."option")
	if not savedOption then
		cm:set_saved_value("ml_"..char:get_forename().." "..char:get_surname().."|"..tostring(char:cqi()).."_".."option", ml_tables.default_option);
	end
end

local buttonLocation_charPanel = true;	
local buttonLocation_preBattle = true;	
local buttonLocation_unitsPanel = true;	

core:add_listener(
	"ml_resetLClickUp",
	"ComponentLClickUp",
	function(context)
		local panel = find_uicomponent(core:get_ui_root(), "character_details_panel");
		return context.string == "button_stats_reset" and is_uicomponent(panel);
	end,
	function(context)
		cm:callback(
			function(context)
				local char = getmlChar();
				if char and not is_agentSelected(char) then
					deleteLoreFrame();
					pulse_uicomponent(loreButton_charPanel.uic, false, 10, false, "active");	
					ml_tables = ml_force_require(char);
					if ml_tables and char:faction():is_human() then
						local savedOption = cm:get_saved_value("ml_"..char:get_forename().." "..char:get_surname().."|"..tostring(char:cqi()).."_".."option")
						if savedOption ~= "Spells for free" then
							updateSkillTable(char);
							local spellSlots = updateSaveTable(false, char);
							local newSpellSlots = {};
							for _, spell in ipairs(spellSlots) do
								for skillname, spellname in pairs(ml_tables.skillnames) do
									if spellname == spell and ml_tables.has_skills[skillname] then
										table.insert(newSpellSlots, spell)
										break;
									end
								end
							end
							resetSaveTable(char);
							spellSlots = updateSaveTable(false, char);
							applySpellDisableEffect(char, newSpellSlots)
							for _, newSpell in ipairs(newSpellSlots) do
								for i, spellSlot in ipairs(spellSlots) do
									if string.find(spellSlot, "Spell Slot") then
										spellSlotSelected = "Spell Slot - "..i.." -";
										spellSlots = updateSaveTable(newSpell, char);
										spellSlotSelected = nil;
										break;	
									end
								end
							end	
						end
					end
				end
			end, 0.1, "resetSkills"
		);
	end,
	true
);

core:add_listener(
	"llrRespec",
	"UITriggerScriptEvent",
	function(context)
		return context:trigger() == "LegendaryLordRespec"
	end,
	function(context)
		local cqi = context:faction_cqi() --: CA_CQI
		local char = cm:get_character_by_cqi(cqi);
		if is_mlChar(char) and not is_agentSelected(char) then
			deleteLoreFrame();
			resetSaveTable(char);
			applySpellDisableEffect(getmlChar(), updateSaveTable(false, char));
			setupInnateSpells(char);
		end
	end,
	true
);

core:add_listener(
	"ml_CharacterSkillPointAllocated",
	"CharacterSkillPointAllocated",
	function(context)
		return is_mlChar(context:character());
	end,
	function(context)
		ml_tables = ml_force_require(context:character());
		if ml_tables and context:character():faction():is_human() and ml_tables.skillnames[context:skill_point_spent_on()] then
			local savedOption = cm:get_saved_value("ml_"..context:character():get_forename().." "..context:character():get_surname().."|"..tostring(context:character():cqi()).."_".."option")
			if savedOption ~= "Spells for free" then
				updateSkillTable(context:character());
				local spellSlots = updateSaveTable(false, context:character());
				local banLore = false;
				if ml_tables.default_rule == "Modified TT 8th edition - Teclis" and ml_tables.loreName[context:skill_point_spent_on()] ~= "Lore of High Magic" then
					local lore = ml_tables.loreName[context:skill_point_spent_on()];
					local loreTable = ml_tables.lores[lore];
					for i, spellSlot in ipairs(spellSlots) do
						if tableContains(loreTable, spellSlot) then
							banLore = true;
							break;
						end
					end
				end				
				if ml_tables.default_rule ~= "Modified TT 8th edition - Teclis" or not banLore then
					if not tableContains(spellSlots, ml_tables.skillnames[context:skill_point_spent_on()]) then
						for i, spellSlot in ipairs(spellSlots) do
							if string.find(spellSlot, "Spell Slot") then
								spellSlotSelected = "Spell Slot - "..i.." -";
								break;
							end
						end
						spellSlots = updateSaveTable(ml_tables.skillnames[context:skill_point_spent_on()], context:character());
						applySpellDisableEffect(context:character(), spellSlots)
						spellSlotSelected = nil;
						if loreButton_charPanel then
							pulse_uicomponent(loreButton_charPanel.uic, true, 10, false, "active");
						end
						core:add_listener(
							"ml_disablePulse",
							"ComponentLClickUp",
							function(context)
								return context.string == "loreButton_charPanel"
							end,
							function(context)
								pulse_uicomponent(loreButton_charPanel.uic, false, 10, false, "active");		
							end,
							false
						);
					end
				end
			end
		end
	end,
	true
);

core:add_listener(
	"ml_spellBrowserPanelOpened",
	"PanelOpenedCampaign",
	function(context)		
		return context.string == "spell_browser"; 
	end,
	function(context)
		editSpellBrowserUI();
	end,
	true
);

core:add_listener(
	"ml_spellBrowserPanelclosed",
	"PanelClosedCampaign",
	function(context)		
		return context.string == "spell_browser"; 
	end,
	function(context)
		if loreFrame then
			Util.centreComponentOnScreen(loreFrame);
			spellBrowserButton:SetState("active");
		end
		--deleteLoreFrame();
	end,
	true
);

--v function(char: CA_CHAR)
function setupAICompletedBattleListener(char)
	core:add_listener(
		"ml_BattleCompleted"..tostring(char:cqi()),
		"ScriptEventPlayerBattleCompleted",
		true,
		function(context)
			ml_tables = ml_force_require(char);
			local charCqi = char:cqi();
			for _, effectBundle in pairs(ml_tables.effectBundles) do
				if char:military_force():has_effect_bundle(effectBundle) then
					cm:remove_effect_bundle_from_characters_force(effectBundle, charCqi);
				end
			end	
		end,
		false
	);
end

core:add_listener(
	"ml_aiPendingBattle",
	"PanelOpenedCampaign", 
	function(context) 
		return context.string == "popup_pre_battle";
	end,
	function(context)
		local pb = cm:model():pending_battle();
		local attackers = pb:secondary_attackers();
		local defenders = pb:secondary_defenders();
		if not pb:attacker():faction():is_human() and is_mlChar(pb:attacker()) then
			randomSpells(pb:attacker());
			setupAICompletedBattleListener(pb:attacker())
		elseif not pb:defender():faction():is_human() and is_mlChar(pb:defender()) then
			randomSpells(pb:defender());
			setupAICompletedBattleListener(pb:defender())
		elseif attackers:num_items() > 0 then
			for i = 0, attackers:num_items() - 1 do
				if is_mlChar(attackers:item_at(i)) then
					randomSpells(attackers:item_at(i));
					setupAICompletedBattleListener(attackers:item_at(i))
				end
			end
		elseif defenders:num_items() > 0 then
			for i = 0, defenders:num_items() - 1 do
				if is_mlChar(defenders:item_at(i)) then
					randomSpells(defenders:item_at(i));
					setupAICompletedBattleListener(defenders:item_at(i))
				end
			end
		end
	end,
	true
);


core:add_listener(
	"ml_ConfederationListener",
	"FactionJoinsConfederation", 
	true,
	function(context)
		if context:confederation():is_human() then
			local characterList = context:confederation():character_list();
			for i = 0, characterList:num_items() - 1 do
				local currentChar = characterList:item_at(i);
				ml_tables = ml_force_require(currentChar);	
				if is_mlChar(currentChar) then
					setupSavedOptions(currentChar);
					setupInnateSpells(currentChar);
				end
			end
		end
	end,
	true
);

core:add_listener(
	"ml_agentCreatedListener",
	"CharacterCreated", 
	true,
	function(context)
		if context:character():faction():is_human() then
			ml_tables = ml_force_require(context:character());
			if is_mlChar(context:character()) then
				setupSavedOptions(context:character());
				setupInnateSpells(context:character());
			end
		end
	end,
	true
);

if buttonLocation_charPanel then
	core:add_listener(
		"ml_loreCharacterPanelOpened",
		"PanelOpenedCampaign",
		function(context)		
			return context.string == "character_details_panel" and not cm:model():pending_battle():is_active(); 
		end,
		function(context)
			createloreButton_charPanel(); 
			if loreFrame then
				spellBrowserButton:SetDisabled(true);
				spellBrowserButton:SetOpacity(50);	
			end			
		end,
		true
	);

	core:add_listener(
		"ml_loreCharacterPanelClosed",
		"PanelClosedCampaign",
		function(context) 
			return context.string == "character_details_panel" and not cm:model():pending_battle():is_active(); 
		end,
		function(context)
			if loreButton_charPanel then
				loreButton_charPanel:Delete();
				loreButton_charPanel = nil;
			end
			deleteLoreFrame();
		end,
		true
	);

	core:add_listener(
		"ml_cycleRightLClickUp",
		"ComponentLClickUp",
		function(context)
			local panel = find_uicomponent(core:get_ui_root(), "character_details_panel");
			return context.string == "button_cycle_right" and is_uicomponent(panel);
		end,
		function(context)
			cm:callback(
				function(context)
					updateButtonVisibility_charPanel();
					deleteLoreFrame();
				end, 0, "checkNamePanelText"
			);		
		end,
		true
	);
	
	core:add_listener(
		"ml_cycleLeftLClickUp",
		"ComponentLClickUp",
		function(context)
			local panel = find_uicomponent(core:get_ui_root(), "character_details_panel");
			return context.string == "button_cycle_left" and is_uicomponent(panel);
		end,
		function(context)
			cm:callback(
				function(context)
					updateButtonVisibility_charPanel();
					deleteLoreFrame();
				end, 0, "checkNamePanelText"
			);	
		end,
		true
	);
	
	core:add_listener(
		"ml_nextShortcutPressed",
		"ShortcutPressed",
		function(context)
			local panel = find_uicomponent(core:get_ui_root(), "character_details_panel");
			return context.string == "select_next" and is_uicomponent(panel);
		end,
		function(context)
			cm:callback(
				function(context)
					updateButtonVisibility_charPanel();
					deleteLoreFrame();
				end, 0, "checkNamePanelText"
			);	
		end,
		true
	);
	
	core:add_listener(
		"ml_prevShortcutPressed",
		"ShortcutPressed",
		function(context)
			local panel = find_uicomponent(core:get_ui_root(), "character_details_panel");
			return context.string == "select_prev" and is_uicomponent(panel);
		end,
		function(context)
			cm:callback(
				function(context)
					updateButtonVisibility_charPanel();
					deleteLoreFrame();
				end, 0, "checkNamePanelText"
			);	
		end,
		true
	);
end

if buttonLocation_preBattle then		
	core:add_listener(
		"ml_preBattlePanelOpened",
		"PanelOpenedCampaign", 
		function(context) 
			return context.string == "popup_pre_battle" and not loreButton_preBattle; 
		end,
		function(context)
			local pb = cm:model():pending_battle();
			if getmlChar() then
				createloreButton_preBattle(pb:battle_type());
			end
		end,
		true
	);
	
	core:add_listener(
		"ml_preBattleCharacterPanelOpened",
		"PanelOpenedCampaign", 
		function(context) 
			return context.string == "character_details_panel" and cm:model():pending_battle():is_active();
		end,
		function(context)
			deleteLoreFrame();
		end,
		true
	);
		
	core:add_listener(
		"ml_preBattlePanelClosed",
		"PanelClosedCampaign",
		function(context) 
			return context.string == "popup_pre_battle"; 
		end,
		function(context)
			if loreButton_preBattle then
				Util.delete(loreButton_preBattle);
				core:remove_listener("loreButton_preBattle_Listener");
				loreButton_preBattle = nil;
			end
			deleteLoreFrame();
		end,
		true
	);
end

if buttonLocation_unitsPanel then
	core:add_listener(
		"ml_unitPanelOpened",
		"PanelOpenedCampaign",
		function(context)		
			return context.string == "units_panel" and not loreButton_unitsPanel; 
		end,
		function(context)
			if getmlChar() then
				createloreButton_unitsPanel();	
			end
		end,
		true
	);

	core:add_listener(
		"ml_unitPanelClosed",
		"PanelClosedCampaign",
		function(context) 
			return context.string == "units_panel"; 
		end,
		function(context)
			if loreButton_unitsPanel then
				loreButton_unitsPanel:Delete();
				loreButton_unitsPanel = nil;
			end
			deleteLoreFrame();
		end,
		true
	);

	core:add_listener(
		"ml_unitPanelCharacterSelected",
		"CharacterSelected", 
		function(context) 
			local panel = find_uicomponent(core:get_ui_root(), "units_panel");
			return is_uicomponent(panel);
		end,
		function(context)
			local char = context:character();
			--cm:callback(
			--	function(context)
					if not loreButton_unitsPanel and is_mlChar(char) then 
						createloreButton_unitsPanel();
					elseif not is_mlChar(char)  then 
						if loreButton_unitsPanel then
							loreButton_unitsPanel:Delete();
							loreButton_unitsPanel = nil;
						end
						deleteLoreFrame();
					end
			--	end, 0, "waitforsmth"
			--);	
		end,
		true
	);
end

--v function()
function ml_setup()
	local characterList = playerFaction:character_list();
	for i = 0, characterList:num_items() - 1 do
		local currentChar = characterList:item_at(i);	
		if is_mlChar(currentChar) then
			ml_tables = ml_force_require(currentChar);
			setupSavedOptions(currentChar);
			setupInnateSpells(currentChar);
		end
	end
end

if cm:is_new_game() then 
	mlLOG_reset();
	ml_setup(); 
else
	local pb = cm:model():pending_battle();
	if find_uicomponent(core:get_ui_root(), "popup_pre_battle") and pb and getmlChar() then
		createloreButton_preBattle(pb:battle_type());
	end
end