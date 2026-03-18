-----------------------------------------------------------------------------------------------------------------------------------------
-- SCENARIOS
-----------------------------------------------------------------------------------------------------------------------------------------
local vagosCoords = PolyZone:Create({
    vector2(173.86,-2023.48),
    vector2(279.92,-1886.36),
    vector2(340.91,-1935.23),
    vector2(235.61,-2059.09)
}, { name = "vagos-1" })

local vagos2Coords = PolyZone:Create({
    vector2(250.38,-2069.70),
    vector2(352.65,-1948.48),
    vector2(464.77,-2055.68),
    vector2(465.53,-2067.05),
    vector2(392.80,-2143.18),
    vector2(355.30,-2154.92),
    vector2(327.65,-2143.56)
}, { name = "vagos-2" })

local familiesCoords = PolyZone:Create({
    vector2(-150.76,-1724.24),
    vector2(-181.82,-1763.64),
    vector2(-233.33,-1725.76),
    vector2(-252.27,-1695.45),
    vector2(-325.76,-1648.48),
    vector2(-268.94,-1540.91),
    vector2(-253.79,-1454.55),
    vector2(-239.39,-1446.97),
    vector2(-137.12,-1538.64),
    vector2(-184.09,-1593.18),
    vector2(-193.18,-1668.94),
    vector2(-179.55,-1704.55)
}, { name = "families-1" })

local families2Coords = PolyZone:Create({
    vector2(-137.12,-1709.85),
    vector2(-50.00,-1611.36),
    vector2(-123.48,-1557.58),
    vector2(-170.45,-1606.82),
    vector2(-171.97,-1675.76)
}, { name = "families-2" })

local families3Coords = PolyZone:Create({
    vector2(-30.30,-1581.82),
    vector2(-99.24,-1525.00),
    vector2(-62.88,-1475.76),
    vector2(0.00,-1468.94),
    vector2(41.67,-1496.21),
    vector2(-15.91,-1565.15)
}, { name = "families-3" })

local families4Coords = PolyZone:Create({
    vector2(-123.48,-1503.79),
    vector2(-193.18,-1442.42),
    vector2(-190.15,-1428.03),
    vector2(-112.88,-1389.02),
    vector2(-81.82,-1383.33),
    vector2(56.82,-1380.30),
    vector2(105.30,-1384.47),
    vector2(123.86,-1397.35),
    vector2(114.77,-1417.42),
    vector2(53.41,-1484.85),
    vector2(10.61,-1454.92),
    vector2(-37.12,-1456.44),
    vector2(-81.06,-1464.77),
    vector2(-114.02,-1509.47)
}, { name = "families-4" })

local thesouthCoords = PolyZone:Create({
    vector2(935.23,-130.68),
    vector2(978.41,-77.65),
    vector2(1048.11,-150.76),
    vector2(1021.21,-177.27),
    vector2(990.15,-168.18),
    vector2(943.56,-140.15)
}, { name = "thesouth" })

local madrazoCoords = PolyZone:Create({
    vector2(1299.24,1189.39),
    vector2(1496.97,1192.42),
    vector2(1513.64,1150.00),
    vector2(1516.67,1030.30),
    vector2(1490.15,1018.94),
    vector2(1436.36,1022.73),
    vector2(1381.06,1040.91),
    vector2(1305.30,1087.12)
}, { name = "madrazo" })

local cartelCoords = PolyZone:Create({
    vector2(445.45,-3026.52),
    vector2(618.94,-3025.00),
    vector2(621.97,-3203.79),
    vector2(606.82,-3203.79),
    vector2(609.09,-3251.52),
    vector2(596.21,-3250.00),
    vector2(598.48,-3294.70),
    vector2(511.36,-3292.42),
    vector2(511.36,-3385.61),
    vector2(464.39,-3389.39),
    vector2(465.91,-3286.36),
    vector2(452.27,-3281.82),
    vector2(438.64,-3235.61),
    vector2(439.39,-3177.27),
    vector2(459.85,-3175.76),
    vector2(457.58,-3116.67),
    vector2(435.61,-3115.15)
}, { name = "cartel" })
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
local Ped = PlayerPedId()
local Coords = GetEntityCoords(Ped)

CreateThread(function()
    while true do
        if vagosCoords:isPointInside(Coords) or vagos2Coords:isPointInside(Coords) or familiesCoords:isPointInside(Coords) or families2Coords:isPointInside(Coords) or families3Coords:isPointInside(Coords) or families4Coords:isPointInside(Coords) or thesouthCoords:isPointInside(Coords) or madrazoCoords:isPointInside(Coords) or cartelCoords:isPointInside(Coords) then
            ClearAreaOfPeds(Coords.x,Coords.y,25.00,50.0,1)
        end
        Wait(0)
    end
end)