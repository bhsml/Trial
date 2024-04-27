


--[[ Using the code from example tutorial: https://otland.net/threads/tutorial-mods-creating-modules-with-extended-opcode.270062/
  Program gets the position and size of both the jump! button and the panel it is in to get the markers for reset function.
  Reset Function brings the jump! button back to the right side of the window and starts again. Either by clicking or reaching end of left side.
  ]]
  
foodeaterButton = nil
foodeaterWindow = nil

local not_moved = true -- Used for unanchoring the jump! button.
local resetted = false -- Used as a lock or destroying old move function.
local random = math.random -- Randomizing the y axis
local sleep_timer = 50 -- Wait or Sleep intervals for executing move.

function init()
  foodeaterButton = modules.client_topmenu.addRightGameToggleButton('foodeaterButton', tr('Food Eater'), '/food_eater/food_eater/food_eater', closing, false, 13)
  foodeaterButton:setOn(false)

  foodeaterWindow = g_ui.displayUI('food_eater')
  foodeaterWindow:setVisible(false)

  -- The panel where the jump! button is in
  allTabs = foodeaterWindow:recursiveGetChildById('allTabs')
  allTabs:setContentWidget(foodeaterWindow:getChildById('optionsTabContent'))
end

--###############################
-- Functions for getting values
--###############################
function getTop()
  return allTabs:getPosition().y
end

function getLeft()
  return allTabs:getPosition().x
end

function getBottom()
  return allTabs:getPosition().y + allTabs:getSize().height - allTabs:backwardsGetWidgetById('Jump!'):getSize().height
end

function getRight()
  return allTabs:getPosition().x + allTabs:getSize().width - allTabs:backwardsGetWidgetById('Jump!'):getSize().width
end

function getButton()
  return allTabs:backwardsGetWidgetById('Jump!')
end


--###############################
-- Functions for moving Button
--###############################
function reset()
    -- Goes back to the right side of the menu and randomly places in any y axis.
    local x = getRight()
    local y = random(getTop(), getBottom()) -- Goes from top to bottom in increasing order
    local button = allTabs:backwardsGetWidgetById("Jump!")
    button:setX(x)
    button:setY(y)
end

function move()
  -- Used for moving the jump! Button. It takes the x position of the button then increments it to the left.
  -- Once it reaches the left side of panel, resets and move again.
  increments = 5
  -- To break the old loop when click on jump! button
  if resetted then
    resetted = false
    return
  end
  
  -- Getting new position for x
  local button = getButton()
  local x = button:getPosition()['x']
  local xNew = x - increments -- New position for x
  
  -- Condition where it resets when it passes or reaches the left side of panel
  if xNew <= getLeft() then
    reset()
    move()
    return
  end
  
  -- Move then sleep
  button:setX(xNew)
  scheduleEvent(move, sleep_timer)
end

function jumpClick()
  -- When user clicks on the jump! button
  if not_moved then
    not_moved = false
    allTabs:backwardsGetWidgetById('Jump!'):breakAnchors()
    move()
  else
    resetted = true
    reset()
    move()
  end
end


--#########
-- Extras
--#########
function terminate()
  foodeaterButton:destroy()
  foodeaterWindow:destroy()
end

function closing()
  if foodeaterButton:isOn() then
    foodeaterWindow:setVisible(false)
    foodeaterButton:setOn(false)
  else
    foodeaterWindow:setVisible(true)
    foodeaterButton:setOn(true)
  end
end

function onMiniWindowClose()
  foodeaterButton:setOn(false)

end