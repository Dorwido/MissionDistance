-----------------------------------------------------------------------------------------------
-- Client Lua Script for MissionDistance
-- Copyright (c) NCsoft. All rights reserved
-----------------------------------------------------------------------------------------------
 
require "Window"
 
-----------------------------------------------------------------------------------------------
-- MissionDistance Module Definition
-----------------------------------------------------------------------------------------------
local MissionDistance = {} 
 
-----------------------------------------------------------------------------------------------
-- Constants
-----------------------------------------------------------------------------------------------
-- e.g. local kiExampleVariableMax = 999
 
-----------------------------------------------------------------------------------------------
-- Initialization
-----------------------------------------------------------------------------------------------
function MissionDistance:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self 

    -- initialize variables here

    return o
end

function MissionDistance:Init()
	local bHasConfigureFunction = false
	local strConfigureButtonText = ""
	local tDependencies = {
		-- "UnitOrPackageName",
	}
    Apollo.RegisterAddon(self, bHasConfigureFunction, strConfigureButtonText, tDependencies)
end
 

-----------------------------------------------------------------------------------------------
-- MissionDistance OnLoad
-----------------------------------------------------------------------------------------------
function MissionDistance:OnLoad()
    -- load our form file
	
	self.timer = ApolloTimer.Create(1.000, true, "OnTimer", self)
	self.marked = {}
end



-----------------------------------------------------------------------------------------------
-- MissionDistance Functions
-----------------------------------------------------------------------------------------------
-- Define general functions here




-- on timer
function MissionDistance:OnTimer()
	-- Do your timer-related stuff here.
	
	local pepCurrent = PlayerPathLib.GetCurrentEpisode()
	if not pepCurrent or GameLib.GetPlayerUnit():IsDead() then
		return
	end
	local tFullMissionList = pepCurrent:GetMissions()
	if not tFullMissionList or #tFullMissionList == 0 then
		return
	end
	local pathWindow = Apollo.FindWindowByName("PathContainer")
	if(pathWindow == nil) then
		return
	end
	for _, pmMission in ipairs(tFullMissionList) do
		if (not pmMission:IsComplete() and pmMission:GetMissionState()>0) then
			local dist = pmMission:GetDistance()
			local pmName = pmMission:GetName()
			local status = pmMission:GetMissionState()
			local pmID = pmMission:GetId()
		--local pixieClickBar = wndClickTimeFrame:GetPixieInfo(1)
			
			local childWindow = pathWindow:FindChildByUserData(pmMission)
			if(childWindow and not self.marked[pmID] and dist < 10000) then
					
					local pixieid=childWindow:AddPixie({ 
						strText = ""..math.floor(dist),
						strFont = "CRB_Interface10",
						
						bLine = false,
						
						crText = {a=1,r=0.49,g=1.00,b=0.72},
						loc = {
							fPoints = {0,0,0,0},
							nOffsets = {0,0,childWindow:GetWidth(),childWindow:GetHeight()}
						},
						flagsText = {
							DT_BOTTOM = true,
							DT_RIGHT = true
						}
	  
					})
					self.marked[pmID] = pixieid
			elseif(childWindow  and dist < 10000) then
					curpixie = childWindow:GetPixieInfo(self.marked[pmID])
					if(curpixie) then
						curpixie.strText = ""..math.floor(dist)
						curpixie.flagsText = {DT_BOTTOM = true,DT_RIGHT = true}
						childWindow:UpdatePixie(self.marked[pmID],curpixie)
					else
						local pixieid=childWindow:AddPixie({ 
						strText = ""..math.floor(dist),
						strFont = "CRB_Interface10",
						
						bLine = false,
						
						crText = {a=1,r=0.49,g=1.00,b=0.72},
						loc = {
							fPoints = {0,0,0,0},
							nOffsets = {0,0,childWindow:GetWidth(),childWindow:GetHeight()}
						},
						flagsText = {
							DT_BOTTOM = true,
							DT_RIGHT = true
						}
	  
						})
						self.marked[pmID] = pixieid
					
					end
					
			
			end
			
			
		end
	
	end
	
	
	
end





-----------------------------------------------------------------------------------------------
-- MissionDistance Instance
-----------------------------------------------------------------------------------------------
local MissionDistanceInst = MissionDistance:new()
MissionDistanceInst:Init()
