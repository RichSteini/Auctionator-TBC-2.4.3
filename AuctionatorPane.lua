
local addonName, addonTable = AuctionatorName, AuctionatorAddon;
local zc = addonTable.zc;
local zz = zc.md

AtrPane = {};
AtrPane.__index = AtrPane;

function AtrPane.create ()

	local pane = {};
	setmetatable (pane,AtrPane);

	pane.fullStackSize	= 0;

	pane.totalItems		= 0;		-- total in bags for this item

	pane.UINeedsUpdate	= false;

	pane.activeSearch	= nil;
	pane.sortedHist		= nil;
	pane.hints			= nil;
	pane.activeScan		= Atr_FindScan (nil);
	
	pane.hlistScrollOffset	= 0;
	
	pane:ClearSearch();
	
	return pane;
end


-----------------------------------------

-- search for specific items needs to supply the IDstring and, if possible, the itemLink although the latter is not required

function AtrPane:DoSearch (searchText, IDstring, itemLink, rescanThreshold)

	self.currIndex			= nil;
	self.histIndex			= nil;
	self.sortedHist			= nil;
	self.hints				= nil;
	
	self.SS_hilite_itemName	= searchText;		-- by name for search summary
	
	Atr_ClearBuyState();

	self.activeScan = Atr_FindScan (nil);
	
	Atr_ClearAll();		-- it's fast, might as well just do it now for cleaner UE
	
	self.UINeedsUpdate = false;		-- will be set when scan finishes
			
	self.activeSearch = Atr_NewSearch (searchText, IDstring, itemLink, rescanThreshold);
	
	if (IDstring) then
		self.activeScan = self.activeSearch:GetFirstScan();
	end
	
	local cacheHit = false;
	
	if (searchText ~= "") then
		if (self:IsScanNil() or self.activeScan.whenScanned == 0) then		-- check whenScanned so we don't rescan cache hits
			self.activeSearch:Start();
		else
			self.UINeedsUpdate = true;
			cacheHit = true;
		end
	else
		if Atr_Search_Button then
			Atr_Search_Button:Enable()
			Atr_Adv_Search_Button:Enable()
		end
	end
	
	return cacheHit;
end

-----------------------------------------

function AtrPane:ClearSearch ()
	self:DoSearch ("");
end

-----------------------------------------

function AtrPane:GetProcessingState ()
	
	if (self.activeSearch) then
		return self.activeSearch.processing_state;
	end
	
	return KM_NULL_STATE;
end

-----------------------------------------

function AtrPane:IsScanNil ()
	
	return (self.activeScan == nil or self.activeScan:IsNil());
	
end


