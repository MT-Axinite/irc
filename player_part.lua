-- This file is licensed under the terms of the BSD 2-clause license.
-- See LICENSE.txt for details.


function irc:player_part(name)
	if not self.joined_players[name] then
		return false, "You are not in the channel"
	end
	self.joined_players[name] = nil
	return true, "You left the channel"
end
 
function irc:player_join(name)
	if self.joined_players[name] then
		return false, "You are already in the channel"
	end
	self.joined_players[name] = true
	return true, "You joined the channel"
end


minetest.register_chatcommand("join", {
	description = "Join the IRC channel",
	privs = {shout=true},
	func = function(name, param)
		return irc:player_join(name)
	end
})
 
minetest.register_chatcommand("part", {
	description = "Part the IRC channel",
	privs = {shout=true},
	func = function(name, param)
		return irc:player_part(name)
	end
})
 
minetest.register_chatcommand("who", {
	description = "Tell who is currently on the channel",
	privs = {},
	func = function(name, param)
		local out, n = { }, 0
		for name in pairs(irc.joined_players) do
			n = n + 1
			out[n] = name
		end
		table.sort(out)
		return true, "Players in channel: "..table.concat(out, ", ")
	end
})

 
minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	irc.joined_players[name] = irc.config.auto_join
end)
 
 
minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	irc.joined_players[name] = nil
end)

function irc:sendLocal(message)
	for name, _ in pairs(self.joined_players) do
		minetest.chat_send_player(name, message)
	end
<<<<<<< HEAD
	irc:logChat(message, name)
=======
	irc:logChat(message)
>>>>>>> bb5f5491939569a0885fdf63fb9fb2ffa1309998
end
