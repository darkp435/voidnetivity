--[[
 Copyright 2025 darkp435

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 ]]
local Players = game:GetService("Players")

local ServerScriptService = game:GetService("ServerScriptService")
local utils = require(ServerScriptService["utils"])

--[[
Module for managing the host system and abstracting it as well as fetching data about the host
Host system is represented via a graph because it aligns better with what the network looks like
]]

local module = {}
module.Hosts = {}

-- Host struct
Host = {}

function Host.new(map, x, y, z)
	return {
		map = map,
		x = x,
		y = y,
		z = z
	}
end

-- hostnames will be represented via an adjacency list, then converted to objects for convenience, pseudocode:
--[[

module {
	hostname: {"edge1", "edge2", ...}
	...
}

]]

--[[
graph is directed and unweighted
adjacency list (should be able to copy into file seamlessly):

{
    voidhome: {"voidtech-gw1", "sys05", "doc37n", "res-1", "water"}
}
]]

-- List of constructed hosts. Each host has 2000 studs allocated, must be between 100k and -100k.
-- voidhome is default host.
-- Maps will be temporary placeholders.
module["Hosts"]["voidhome"] = Host.new("HOME", 0, 0, 0)
-- These next two hosts used to be placeholders but I'd figure to keep it in.
module["Hosts"]["foo"] = Host.new("PLACEHOLDER", 0, 0, 2000)
module["Hosts"]["bar"] = Host.new("PLACEHOLDER", 0, 0, 4000)
module["Hosts"]["water"] = Host.new("PLACEHOLDER", 0, 0, 6000)
module["Hosts"]["ndtf"] = Host.new("PLACEHOLDER", 0, 0, 8000)
module["Hosts"]["ndtf-wg1"] = Host.new("PLACEHOLDER", 0, 0, 10000)
module["Hosts"]["ndtf-wg2"] = Host.new("PLACEHOLDER", 0, 0, 12000)
module["Hosts"]["ndtf-w3c"] = Host.new("PLACEHOLDER", 0, 0, 14000)
module["Hosts"]["ndtf-ise"] = Host.new("PLACEHOLDER", 0, 0, 16000)
module["Hosts"]["ndtf-iseg"] = Host.new("PLACEHOLDER", 0, 0, 18000)
module["Hosts"]["lemon"] = Host.new("PLACEHOLDER", 0, 0, 20000)
module["Hosts"]["lemon-ade"] = Host.new("PLACEHOLDER", 0, 0, 22000)
module["Hosts"]["grass"] = Host.new("PLACEHOLDER", 0, 0, 24000)
module["Hosts"]["silicon-net"] = Host.new("PLACEHOLDER", 0, 0, 26000)
module["Hosts"]["pixel435"] = Host.new("PLACEHOLDER", 0, 0, 28000)
module["Hosts"]["sub-ndtf"] = Host.new("PLACEHOLDER", 0, 0, 30000)
module["Hosts"]["ndtf-satcom"] = Host.new("PLACEHOLDER", 0, 0, 32000)
module["Hosts"]["gubby"] = Host.new("PLACEHOLDER", 0, 0, 34000)
module["Hosts"]["jerseysoft"] = Host.new("PLACEHOLDER", 0, 0, 36000)
module["Hosts"]["jerseysoft-satcom"] = Host.new("PLACEHOLDER", 0, 0, 38000)
module["Hosts"]["jerseylabs"] = Host.new("PLACEHOLDER", 0, 0, 40000)
module["Hosts"]["jerseysoft-gw"] = Host.new("PLACEHOLDER", 0, 0, 42000)
module["Hosts"]["jerseysoft-mn"] = Host.new("PLACEHOLDER", 0, 0, 44000)
module["Hosts"]["jerseysoft-hq"] = Host.new("PLACEHOLDER", 0, 0, 46000)
module["Hosts"]["ndtflabs"] = Host.new("PLACEHOLDER", 0, 0, 48000)
module["Hosts"]["boxy"] = Host.new("PLACEHOLDER", 0, 0, 50000)
module["Hosts"]["restmain"] = Host.new("PLACEHOLDER", 0, 0, 52000)
module["Hosts"]["intls"] = Host.new("PLACEHOLDER", 0, 0, 54000)
module["Hosts"]["asynco"] = Host.new("PLACEHOLDER", 0, 0, 56000)
module["Hosts"]["ndtf-rfc"] = Host.new("PLACEHOLDER", 0, 0, 58000)
module["Hosts"]["prop"] = Host.new("PLACEHOLDER", 0, 0, 60000)
module["Hosts"]["mocha"] = Host.new("PLACEHOLDER", 0, 0, 62000)
module["Hosts"]["seren-co"] = Host.new("PLACEHOLDER", 0, 0, 64000)
module["Hosts"]["little"] = Host.new("PLACEHOLDER", 0, 0, 66000)
module["Hosts"]["franksoft"] = Host.new("PLACEHOLDER", 0, 0, 68000)
module["Hosts"]["res-1"] = Host.new("PLACEHOLDER", 0, 0, 70000)
module["Hosts"]["res-2"] = Host.new("PLACEHOLDER", 0, 0, 72000)
module["Hosts"]["res-3"] = Host.new("PLACEHOLDER", 0, 0, 74000)
module["Hosts"]["res-4"] = Host.new("PLACEHOLDER", 0, 0, 76000)
module["Hosts"]["res-5"] = Host.new("PLACEHOLDER", 0, 0, 78000)
module["Hosts"]["unires"] = Host.new("PLACEHOLDER", 0, 0, 80000)
module["Hosts"]["love"] = Host.new("PLACEHOLDER", 0, 0, 82000)
module["Hosts"]["trust"] = Host.new("PLACEHOLDER", 0, 0, 84000)
module["Hosts"]["toxicate-ent"] = Host.new("PLACEHOLDER", 0, 0, 86000)
module["Hosts"]["toxicate-mn"] = Host.new("PLACEHOLDER", 0, 0, 88000)
module["Hosts"]["toxicate-sub1"] = Host.new("PLACEHOLDER", 0, 0, 90000)
module["Hosts"]["toxicate-sub2"] = Host.new("PLACEHOLDER", 0, 0, 92000)
module["Hosts"]["toxicate-satcom"] = Host.new("PLACEHOLDER", 0, 0, 94000)
module["Hosts"]["toxicate-gw"] = Host.new("PLACEHOLDER", 0, 0, 96000)
module["Hosts"]["ndtf-gw"] = Host.new("PLACEHOLDER", 0, 0, 98000)
module["Hosts"]["darkn"] = Host.new("PLACEHOLDER", 0, 0, 100000)
module["Hosts"]["crypto-gw"] = Host.new("PLACEHOLDER", 0, 0, -2000)
module["Hosts"]["crypto-ent"] = Host.new("PLACEHOLDER", 0, 0, -4000)
module["Hosts"]["crypto-stcm"] = Host.new("PLACEHOLDER", 0, 0, -8000)
module["Hosts"]["crypto-trd"] = Host.new("PLACEHOLDER", 0, 0, -10000)
module["Hosts"]["crypto-mn"] = Host.new("PLACEHOLDER", 0, 0, -12000)
module["Hosts"]["dent"] = Host.new("PLACEHOLDER", 0, 0, -14000)
module["Hosts"]["glisten-gw"] = Host.new("PLACEHOLDER", 0, 0, -16000)
module["Hosts"]["glisten-mn"] = Host.new("PLACEHOLDER", 0, 0, -18000)
module["Hosts"]["tx-sat"] = Host.new("PLACEHOLDER", 0, 0, -20000)
module["Hosts"]["ajax"] = Host.new("PLACEHOLDER", 0, 0, -22000)
module["Hosts"]["xjax"] = Host.new("PLACEHOLDER", 0, 0, -24000)
module["Hosts"]["document"] = Host.new("PLACEHOLDER", 0, 0, -26000)
module["Hosts"]["quokka"] = Host.new("PLACEHOLDER", 0, 0, -28000)
module["Hosts"]["quokka-gw"] = Host.new("PLACEHOLDER", 0, 0, -30000)
module["Hosts"]["quokka-hq"] = Host.new("PLACEHOLDER", 0, 0, -32000)
module["Hosts"]["quokka-pub"] = Host.new("PLACEHOLDER", 0, 0, -34000)
module["Hosts"]["quokka-stcm"] = Host.new("PLACEHOLDER", 0, 0, -36000)
module["Hosts"]["quokka-sub1"] = Host.new("PLACEHOLDER", 0, 0, -38000)
module["Hosts"]["quokka-sub2"] = Host.new("PLACEHOLDER", 0, 0, -40000)
module["Hosts"]["quokka-sub3"] = Host.new("PLACEHOLDER", 0, 0, -42000)
module["Hosts"]["quokka-ent"] = Host.new("PLACEHOLDER", 0, 0, -44000)
module["Hosts"]["ndtf-misc"] = Host.new("PLACEHOLDER", 0, 0, -46000)
module["Hosts"]["ndtf-dmp"] = Host.new("PLACEHOLDER", 0, 0, -48000)
module["Hosts"]["ndtf-mail"] = Host.new("PLACEHOLDER", 0, 0, -50000)
module["Hosts"]["ndtf-wgun"] = Host.new("PLACEHOLDER", 0, 0, -52000)
module["Hosts"]["ndtf-aiwg"] = Host.new("PLACEHOLDER", 0, 0, -54000)
module["Hosts"]["ndtf-nwg"] = Host.new("PLACEHOLDER", 0, 0, -56000)
module["Hosts"]["res-ai"] = Host.new("PLACEHOLDER", 0, 0, -58000)
module["Hosts"]["telnet"] = Host.new("PLACEHOLDER", 0, 0, -60000)
module["Hosts"]["ndtf-sec"] = Host.new("PLACEHOLDER", 0, 0, -62000)
module["Hosts"]["quokka-sec"] = Host.new("PLACEHOLDER", 0, 0, -64000)
module["Hosts"]["telnet-mkt"] = Host.new("PLACEHOLDER", 0, 0, -68000)
module["Hosts"]["linux"] = Host.new("PLACEHOLDER", 0, 0, -70000)
module["Hosts"]["linux-disc"] = Host.new("PLACEHOLDER", 0, 0, -72000)
module["Hosts"]["linux-dmp"] = Host.new("PLACEHOLDER", 0, 0, -74000)
module["Hosts"]["linux-pub"] = Host.new("PLACEHOLDER", 0, 0, -76000)
module["Hosts"]["htmco"] = Host.new("PLACEHOLDER", 0, 0, -78000)
module["Hosts"]["ndtf-w3c-htm"] = Host.new("PLACEHOLDER", 0, 0, -80000)
module["Hosts"]["rfc-pub"] = Host.new("PLACEHOLDER", 0, 0, -82000)
module["Hosts"]["ephmco"] = Host.new("PLACEHOLDER", 0, 0, -84000)
module["Hosts"]["ephmco-pub"] = Host.new("PLACEHOLDER", 0, 0, -86000)
module["Hosts"]["ephmco-disc"] = Host.new("PLACEHOLDER", 0, 0, -88000)
module["Hosts"]["ndtf-discstcm"] = Host.new("PLACEHOLDER", 0, 0, -90000)
module["Hosts"]["guidance"] = Host.new("PLACEHOLDER", 0, 0, -92000)
module["Hosts"]["gluttony"] = Host.new("PLACEHOLDER", 0, 0, -94000)
module["Hosts"]["gluttony-mn"] = Host.new("PLACEHOLDER", 0, 0, -96000)
module["Hosts"]["key"] = Host.new("PLACEHOLDER", 0, 0, -98000)
module["Hosts"]["msc"] = Host.new("PLACEHOLDER", 0, 0, -10000)
module["Hosts"]["betrayal"] = Host.new("PLACEHOLDER", 0, 2000, 0)
module["Hosts"]["min-host"] = Host.new("PLACEHOLDER", 0, 2000, 2000)
module["Hosts"]["hostserv"] = Host.new("PLACEHOLDER", 0, 2000, 4000)
module["Hosts"]["uninet"] = Host.new("PLACEHOLDER", 0, 2000, 6000)
module["Hosts"]["unitools"] = Host.new("PLACEHOLDER", 0, 2000, 8000)
module["Hosts"]["void"] = Host.new("PLACEHOLDER", 0, 2000, 10000)
module["Hosts"]["voidtech"] = Host.new("PLACEHOLDER", 0, 2000, 12000)
module["Hosts"]["voidtech-web"] = Host.new("PLACEHOLDER", 0, 2000, 14000)
module["Hosts"]["voidtech-mn"] = Host.new("PLACEHOLDER", 0, 2000, 16000)
module["Hosts"]["voidtech-queries"] = Host.new("PLACEHOLDER", 0, 2000, 18000)
module["Hosts"]["voidtech-marketing"] = Host.new("PLACEHOLDER", 0, 2000, 20000)
module["Hosts"]["voidtech-satcom"] = Host.new("PLACEHOLDER", 0, 2000, 22000)
module["Hosts"]["voidtech-gw1"] = Host.new("PLACEHOLDER", 0, 2000, 24000)
module["Hosts"]["voidtech-gw2"] = Host.new("PLACEHOLDER", 0, 2000, 26000)
module["Hosts"]["voidtech-disc1"] = Host.new("PLACEHOLDER", 0, 2000, 28000)
module["Hosts"]["voidtech-disc2"] = Host.new("PLACEHOLDER", 0, 2000, 30000)
module["Hosts"]["voidtech-disc3"] = Host.new("PLACEHOLDER", 0, 2000, 32000)
module["Hosts"]["voidtech-lnk"] = Host.new("PLACEHOLDER", 0, 2000, 34000)
module["Hosts"]["voidtech-dmp"] = Host.new("PLACEHOLDER", 0, 2000, 36000)
module["Hosts"]["voidtech-docs"] = Host.new("PLACEHOLDER", 0, 2000, 38000)
module["Hosts"]["fibreglass"] = Host.new("PLACEHOLDER", 0, 2000, 40000)
module["Hosts"]["netmon"] = Host.new("PLACEHOLDER", 0, 2000, 42000)
module["Hosts"]["sys05"] = Host.new("PLACEHOLDER", 0, 2000, 44000)
module["Hosts"]["x24x"] = Host.new("PLACEHOLDER", 0, 2000, 46000)
module["Hosts"]["1337co"] = Host.new("PLACEHOLDER", 0, 2000, 48000)
module["Hosts"]["org31173"] = Host.new("PLACEHOLDER", 0, 2000, 50000)
module["Hosts"]["doc37n"] = Host.new("PLACEHOLDER", 0, 2000, 52000)
module["Hosts"]["castle"] = Host.new("PLACEHOLDER", 0, 2000, 54000)
module["Hosts"]["mininet"] = Host.new("PLACEHOLDER", 0, 2000, 56000)
module["Hosts"]["q1"] = Host.new("PLACEHOLDER", 0, 2000, 58000)

-- Graph representing the hosts and their connections
module["Graph"] = {
    voidhome = {"voidtech-gw1", "sys05", "doc37n", "res-1", "water"}
}

--- General function to get the host object from the hostname.
function module.getHostFromName(name: string): table
	return module[name]
end

--- Function to get the map name of the host.
function module.getMap(host: string): string
	return module[host]:getMap()
end

-- TODO: the CurrentHost attribute currently has no setattribute
function module.getUsersOnHost(host: string): table
	local users = {}

	for player: Player in Players:GetPlayers() do
		if player:GetAttribute("CurrentHost") == host then
            table.insert(users, player)
		end
	end

	return users
end

function module.setUserOnHost(user: Player, host: string)
	user:SetAttribute("CurrentHost", host)
end

function module.hostIsNextTo(origin: string, target: string)
	local adjacentHosts = module["Graph"][origin]

	if utils.linearSearch(adjacentHosts, target) == -1 then
		return false
	else
		return true
	end
end

return module