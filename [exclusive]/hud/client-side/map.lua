-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local radarVisible = false
local textureLoaded = false

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	if LoadTexture("circlemap") then
		textureLoaded = true
		SetMinimapClipType(1)
		AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")
		SetBlipAlpha(GetNorthRadarBlip(), 0.0)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEPOSITION
-----------------------------------------------------------------------------------------------------------------------------------------
function UpdatePosition()
	local miniMapScale = GetminiMapScale()
	local baseMinimap_blur = miniMapScale.minimap_blur
	local baseMinimap_mask = miniMapScale.minimap_mask
	local baseMinimap = miniMapScale.minimap

	-- ajuste fino de posição
	local xOffset = -0.012
	local yOffset = -0.055

	SetMinimapComponentPosition("minimap", "L", "B", baseMinimap.x + xOffset, baseMinimap.y + yOffset, baseMinimap.width, baseMinimap.height)
	SetMinimapComponentPosition("minimap_blur", "L", "B", baseMinimap_blur.x + xOffset, baseMinimap_blur.y + yOffset, baseMinimap_blur.width, baseMinimap_blur.height)
	SetMinimapComponentPosition("minimap_mask", "L", "B", baseMinimap_mask.x + xOffset, baseMinimap_mask.y + yOffset, baseMinimap_mask.width, baseMinimap_mask.height)

	SetBigmapActive(true, false)
	Wait(0)
	SetBigmapActive(false, false)

	SetRadarBigmapEnabled(true, false)
	Wait(0)
	SetRadarBigmapEnabled(false, false)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- RADAR ONLY IN VEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local inVehicle = IsPedInAnyVehicle(ped, false)

		if inVehicle and not radarVisible then
			DisplayRadar(true)
			Wait(150)
			UpdatePosition()
			radarVisible = true
		elseif not inVehicle and radarVisible then
			DisplayRadar(false)
			radarVisible = false
		end

		Wait(500)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- REAPPLY ON RESOLUTION CHANGE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local lastX, lastY = GetActiveScreenResolution()

	while true do
		local currentX, currentY = GetActiveScreenResolution()

		if currentX ~= lastX or currentY ~= lastY then
			lastX, lastY = currentX, currentY

			if radarVisible then
				Wait(150)
				UpdatePosition()
			end
		end

		Wait(2000)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- MINIMAP SCALE (FORCED)
-----------------------------------------------------------------------------------------------------------------------------------------
function GetminiMapScale()
	return {
		minimap_blur = {
			x = -0.031,
			y = 0.020,
			width = 0.288,
			height = 0.265
		},
		minimap_mask = {
			x = 0.118,
			y = 0.440,
			width = 0.092,
			height = -0.135
		},
		minimap = {
			x = -0.025,
			y = -0.030,
			width = 0.2005,
			height = 0.168
		}
	}
end