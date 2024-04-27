# Trial

<details open>
<summary>Questions 1-4</summary>
## Q1 - Fix or improve the implementation of the below methods
local function releaseStorage(player)
  player:setStorageValue(1000, -1)
end

function onLogout(player)
  if player:getStorageValue(1000) == 1 then
    addEvent(releaseStorage, 1000, player:getId()) -- pass value instead of reference
  end
  
  return true
end

-- SQL, LUA
## Q2 - Fix or improve the implementation of the below method
function printSmallGuildNames(memberCount)
-- this method is supposed to print names of all guilds that have less than memberCount max members
  local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
  local result = db.storeQuery(string.format(selectGuildQuery, memberCount)) -- removing id based on function .getString()
  local guildName = result.getString("name") -- assuming this returns a long string of guild names rather than an iterator
  print(guildName)
end


--LUA
## Q3 - Fix or improve the name and the implementation of the below method
function remove_member_from_PlayerParty(playerId, membername)
  player = Player(playerId)
  local party = player:getParty()
  for _, member in pairs(party:getMembers()) do -- What is difference between playerId and membername? Additionally it seems that Player are returned from getMembers()
    if member.getName() == membername then -- Assuming that there exist a membername then Player must have something similar to a variable called name
      party:removeMember(member)
	  break
    end
  end
end


--C++
## Q4 - Assume all method calls work fine. Fix the memory leak issue in below method

void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
  Player* player = g_game.getPlayerByName(recipient); // Think it returns a copy
  if (!player) {
    player = new Player(nullptr);
    if (!IOLoginData::loadPlayerByName(player, recipient)) {
		delete (player); // Executes when logindata does not exist?
      return;}
    }
    
  Item* item = Item::CreateItem(itemId);
  
  if (!item) {
	delete (player) // Not in use anymore
    return;
  }
  
  g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);
  
  if (player->isOffline()) {
    IOLoginData::savePlayer(player);
	delete (Item);   // Deleting remnant item before leaving function
	delete (player); // executes because don't need player since it is offline
  }
}
</details>


<details open>
<summary>Question 5: Frigo Animation</summary>


https://github.com/bhsml/Trial/assets/168249198/01c146dd-eff9-42a7-970c-e1efdf79ca35


  
</details>


<details open>
<summary>Question 7: Jumping Button</summary>

https://github.com/bhsml/Trial/assets/168249198/9e481682-5060-44db-8ea8-b99c688e199f


</details>
