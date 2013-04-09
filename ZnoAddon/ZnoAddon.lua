function znoLoad()
	frZnoAddon:SetScript("OnEvent", znoEvent);
	frZnoAddon:RegisterEvent("MERCHANT_SHOW");
	frZnoAddon:RegisterEvent("VARIABLES_LOADED");
	frZnoAddon:RegisterEvent("LOOT_OPENED");
	frZnoAddon:RegisterEvent("LOOT_SLOT_CHANGED");
	frZnoAddon:RegisterEvent("CHAT_MSG_SYSTEM");
	frZnoAddon:RegisterEvent("LOOT_CLOSED");
	frZnoAddon:RegisterEvent("OPEN_MASTER_LOOT_LIST");
	frZnoAddon:RegisterEvent("UPDATE_MASTER_LOOT_LIST");
	SLASH_ZNOADDON1, SLASH_ZNOADDON2 = '/zno', '/znoaddon';
end

function SlashCmdList.ZNOADDON(msg, editbox)
	if zno_mode==nil then
		zno_mode=0;
	end
	zno_mode = zno_mode + 1;
	if zno_mode >= 5 then
		zno_mode = 0;
	end
	if msg =="ownonly" then zno_mode=0;
		elseif msg =="own" then zno_mode=1;
		elseif msg =="guild" then zno_mode=2;
		elseif msg =="guildonly" then zno_mode=3;
		elseif msg =="off" then zno_mode=4;
		else DEFAULT_CHAT_FRAME:AddMessage("/ar ownonly/own/guild/guildonly/off",255,255,0); 
	end

	znoStatus();
end

function znoEvent(self, event, ...)
	if zno_mode==nil then
		zno_mode=0;
	end
	
	Log(event);

	if (event=="MERCHANT_SHOW" and CanMerchantRepair()==1) then
		repairAllCost, canRepair = GetRepairAllCost();
		if (canRepair==1) then
			if(zno_mode<=1) then
				if( repairAllCost<=GetMoney() ) then
					RepairAllItems(0);
					DEFAULT_CHAT_FRAME:AddMessage("Your items have been repaired for "..GetCoinText(repairAllCost,", ")..".",255,255,0);
				else
					DEFAULT_CHAT_FRAME:AddMessage("You don't have enough money for repair!",255,0,0);
				end
			end

			if(zno_mode==2 or zno_mode==3)then
				RepairAllItems(1);
			end

			if(zno_mode==2) then
				if( repairAllCost<=GetMoney() ) then
					RepairAllItems(0);
					DEFAULT_CHAT_FRAME:AddMessage("Your items have been repaired for "..GetCoinText(repairAllCost,", ")..".",255,255,0);
				else
					DEFAULT_CHAT_FRAME:AddMessage("You don't have enough money for repair!",255,0,0);
				end
			end		
		end
	end
	
	if (event=="LOOT_OPENED") then
		DEFAULT_CHAT_FRAME:AddMessage("ZnoAddon - Loot Window Opened!",255,255,0);
		numItems = GetNumLootItems();
		for i=1,numItems,1 do
			Log(GetLootSlotLink(i));
		end
	end
	
	if( event == "LOOT_SLOT_CHANGED" ) then
		DEFAULT_CHAT_FRAME:AddMessage("ZnoAddon - Loot Slot Changed!",255,255,0);
	end
	
	if(event=="LOOT_CLOSED")then
		DEFAULT_CHAT_FRAME:AddMessage("ZnoAddon - Loot Window Closed!", 255, 255, 0);
	end
	
	if(event=="OPEN_MASTER_LOOT_LIST")then
		DEFAULT_CHAT_FRAME:AddMessage("ZnoAddon - Master Loot List!", 255, 255, 0);
	end
	
	if(event=="UPDATE_MASTER_LOOT_LIST")then
		DEFAULT_CHAT_FRAME:AddMessage("ZnoAddon - Update Master Loot List!", 255, 255, 0);
	end
	
	if( event == "CHAT_MSG_SYSTEM") then
		local arg1 = ...;
		local beginIndex, endIndex = string.find(arg1, "roll");
		Log(tostring(beginIndex).." - "..tostring(endIndex));
		if( beginIndex ~= nil) then
			DEFAULT_CHAT_FRAME:AddMessage("ZnoAddon - Roll Message Found! "..arg1, 255, 255, 0);
		end
	end

	if (event=="VARIABLES_LOADED") then
		znoStatus();
	end

end


function znoStatus()
	local modetext="";
	if(zno_mode==0)then modetext="I love you Dekba."; end
	if(zno_mode==1)then modetext="try to repair from own money first, repair from guild bank if fails"; end
	if(zno_mode==2)then modetext="try to repair from guild bank first, repair from own money if fails"; end
	if(zno_mode==3)then modetext="repair only from guild bank"; end
	if(zno_mode==4)then modetext="automatic repairs off"; end
	DEFAULT_CHAT_FRAME:AddMessage("ZnoAddon info: "..modetext,255,255,0);
	modetext = ""..zno_mode;
	DEFAULT_CHAT_FRAME:AddMessage("ZnoAddon zno_mode: "..modetext,0,128,255);
end

function Log(msg)
	DEFAULT_CHAT_FRAME:AddMessage("ZnoAddon - "..msg, 255, 255, 0);
end