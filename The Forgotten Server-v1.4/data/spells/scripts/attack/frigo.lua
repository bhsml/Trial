
--[[
    Programmed it by looking at the video for question 5. Looked at the frames or differences and mark the area in STEPS matrix.
    Though it did not work the first time because missed the overlapping sprites. Completed it by looking at the repeats of the last two smaller tornadoes that ended on STEP4.
    
]]
-- Areas
local AREA_EMPTY = {
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 3, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0}
}

-- Seems the tables are inverse i.e. Left is Right, and Up is Down
local STEP1 = {
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{0, 1, 0, 0, 0, 0, 0},
	{1, 0, 0, 3, 0, 0, 1},
	{0, 1, 0, 0, 0, 0, 0},
	{0, 0, 1, 0, 0, 0, 0},
	{0, 0, 0, 1, 0, 0, 0}
}

local STEP2 = {
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 1, 0, 1, 0, 0},
	{0, 0, 0, 0, 0, 1, 0},
	{0, 0, 0, 3, 0, 0, 0},
	{0, 0, 0, 1, 0, 1, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0}
}

local STEP3 = {
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 1, 3, 1, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 1, 0, 1, 0, 0},
	{0, 0, 0, 0, 0, 0, 0}
}

local STEP4 = {
	{0, 0, 0, 1, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 1, 0, 0, 0},
	{0, 0, 0, 3, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0}
}

-- Maybe the repeats end here

local steps = {STEP1, STEP2, STEP3, STEP4} -- Holds the CombatArea matrix that is used for frigo
local combats = {} -- Used for holding the effects and the animation of frigo

--##########################
--# Build the combat Table #
--##########################

local function buildCombat(stepArea)
  -- param - stepArea: Area matrix for inserting into combat areas
  -- Function for setting up the Combat instances where the sprites ICETORNADO and area are the only effects.
  local result = Combat()
  result:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
  result:setArea(createCombatArea(stepArea))
  return result
end


local function build()
  -- Builds the combat instances table
  for i = 1, #steps do
    combat = buildCombat(steps[i])
    table.insert(combats, combat)
  end
end


--################
--# Commit Build #
--################
build()

--###############################
--# Game Interface: onCastSpell #
--###############################

local function combatFunction(combat, creature, variant)
  -- Function use for addEvent function to execute combat
  return combat:execute(creature, variant)
end

local function animation(pid, variant)
  -- @param pid: player id
  -- @param variant: data used for combat:execute
  -- Loads the frigo animation by repeating the template three times into the addEvent.
  local milliseconds = 0 -- Starting milliseconds for addEvent
  local interval = 250   -- interval milliseconds
  
  for i = 1, 3 do
    for _, combat in pairs(combats) do
      addEvent(combatFunction, milliseconds, combat, pid, variant)
      milliseconds = milliseconds + interval
    end
  end
end

  
-- Interface Casting Spell
function onCastSpell(creature, variant)
  animation(Player(creature):getId(),variant) -- Running the animation for frigo
  return true
end