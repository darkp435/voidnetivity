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

local Greediness = {
	NotGreedy = 0,
	Slight = 1,
	Moderate = 2,
	Greedy = 3,
	Very = 4,
	Extreme = 5,
	Max = 6
}

table.freeze(Greediness)

--[[
Module for managing the host system and abstracting it as well as fetching data about the host
Host system is represented via a graph because it aligns better with what the network looks like
]]

-- Size of each dimension (except Y in the future) of the host
local HOST_SIZE = 2000
-- Half of the size of the host in terms of X and Z, useful since CFrame is based on the center
local HALF_HOST_SIZE = HOST_SIZE / 2

-- ### Host System
-- Manages hosts and provides an API to access it. It does NOT manage
-- the files each host has since it's different for each player,
-- so that data is stored in shared-data-module.luau
local module = {}
module.Hosts = {}

type HostStruct = {map: string, x: number, y: number, z: number}

local function newHost(map: string, x: number, y: number, z: number): HostStruct
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

--* The host system will be reworked due to the fact that having hosts 100,000 studs from the origin is VERY unstable
--* That will happen in the future as I've already wrote the code for this very inefficient system.
--* The new system will work by maintaing a list of size equivalent to the server size of slots that will
--* have true for unoccupied, and false for occupied. The reason the size is equivalent to the maximum
--* server side is because the maximum amount of active hosts is 1 player on each host in the server.

module["Hosts"]["voidhome"] = newHost("HOME", 0, 0, 0)
-- These next two hosts used to be placeholders but I'd figure to keep it in for historical reasons
module["Hosts"]["foo"] = newHost("PLACEHOLDER", 0, 0, 2000)
module["Hosts"]["bar"] = newHost("PLACEHOLDER", 0, 0, 4000)
module["Hosts"]["water"] = newHost("PLACEHOLDER", 0, 0, 6000)
module["Hosts"]["ndtf"] = newHost("PLACEHOLDER", 0, 0, 8000)
module["Hosts"]["ndtf-wg1"] = newHost("PLACEHOLDER", 0, 0, 10000)
module["Hosts"]["ndtf-wg2"] = newHost("PLACEHOLDER", 0, 0, 12000)
module["Hosts"]["ndtf-w3c"] = newHost("PLACEHOLDER", 0, 0, 14000)
module["Hosts"]["ndtf-ise"] = newHost("PLACEHOLDER", 0, 0, 16000)
module["Hosts"]["ndtf-iseg"] = newHost("PLACEHOLDER", 0, 0, 18000)
module["Hosts"]["lemon"] = newHost("PLACEHOLDER", 0, 0, 20000)
module["Hosts"]["lemon-ade"] = newHost("PLACEHOLDER", 0, 0, 22000)
module["Hosts"]["grass"] = newHost("PLACEHOLDER", 0, 0, 24000)
module["Hosts"]["silicon-net"] = newHost("PLACEHOLDER", 0, 0, 26000)
module["Hosts"]["pixel435"] = newHost("PLACEHOLDER", 0, 0, 28000)
module["Hosts"]["sub-ndtf"] = newHost("PLACEHOLDER", 0, 0, 30000)
module["Hosts"]["ndtf-satcom"] = newHost("PLACEHOLDER", 0, 0, 32000)
module["Hosts"]["gubby"] = newHost("PLACEHOLDER", 0, 0, 34000)
module["Hosts"]["jerseysoft"] = newHost("PLACEHOLDER", 0, 0, 36000)
module["Hosts"]["jerseysoft-satcom"] = newHost("PLACEHOLDER", 0, 0, 38000)
module["Hosts"]["jerseylabs"] = newHost("PLACEHOLDER", 0, 0, 40000)
module["Hosts"]["jerseysoft-gw"] = newHost("PLACEHOLDER", 0, 0, 42000)
module["Hosts"]["jerseysoft-mn"] = newHost("PLACEHOLDER", 0, 0, 44000)
module["Hosts"]["jerseysoft-hq"] = newHost("PLACEHOLDER", 0, 0, 46000)
module["Hosts"]["ndtflabs"] = newHost("PLACEHOLDER", 0, 0, 48000)
module["Hosts"]["boxy"] = newHost("PLACEHOLDER", 0, 0, 50000)
module["Hosts"]["restmain"] = newHost("PLACEHOLDER", 0, 0, 52000)
module["Hosts"]["intls"] = newHost("PLACEHOLDER", 0, 0, 54000)
module["Hosts"]["asynco"] = newHost("PLACEHOLDER", 0, 0, 56000)
module["Hosts"]["ndtf-rfc"] = newHost("PLACEHOLDER", 0, 0, 58000)
module["Hosts"]["prop"] = newHost("PLACEHOLDER", 0, 0, 60000)
module["Hosts"]["mocha"] = newHost("PLACEHOLDER", 0, 0, 62000)
module["Hosts"]["seren-co"] = newHost("PLACEHOLDER", 0, 0, 64000)
module["Hosts"]["little"] = newHost("PLACEHOLDER", 0, 0, 66000)
module["Hosts"]["franksoft"] = newHost("PLACEHOLDER", 0, 0, 68000)
module["Hosts"]["res-1"] = newHost("PLACEHOLDER", 0, 0, 70000)
module["Hosts"]["res-2"] = newHost("PLACEHOLDER", 0, 0, 72000)
module["Hosts"]["res-3"] = newHost("PLACEHOLDER", 0, 0, 74000)
module["Hosts"]["res-4"] = newHost("PLACEHOLDER", 0, 0, 76000)
module["Hosts"]["res-5"] = newHost("PLACEHOLDER", 0, 0, 78000)
module["Hosts"]["unires"] = newHost("PLACEHOLDER", 0, 0, 80000);
module["Hosts"]["love"] = newHost("PLACEHOLDER", 0, 0, 82000)
module["Hosts"]["trust"] = newHost("PLACEHOLDER", 0, 0, 84000)
module["Hosts"]["toxicate-ent"] = newHost("PLACEHOLDER", 0, 0, 86000)
module["Hosts"]["toxicate-mn"] = newHost("PLACEHOLDER", 0, 0, 88000)
module["Hosts"]["toxicate-sub1"] = newHost("PLACEHOLDER", 0, 0, 90000)
module["Hosts"]["toxicate-sub2"] = newHost("PLACEHOLDER", 0, 0, 92000)
module["Hosts"]["toxicate-satcom"] = newHost("PLACEHOLDER", 0, 0, 94000)
module["Hosts"]["toxicate-gw"] = newHost("PLACEHOLDER", 0, 0, 96000)
module["Hosts"]["ndtf-gw"] = newHost("PLACEHOLDER", 0, 0, 98000)
module["Hosts"]["darkn"] = newHost("PLACEHOLDER", 0, 0, 100000)
module["Hosts"]["crypto-gw"] = newHost("PLACEHOLDER", 0, 0, -2000)
module["Hosts"]["crypto-ent"] = newHost("PLACEHOLDER", 0, 0, -4000)
module["Hosts"]["crypto-stcm"] = newHost("PLACEHOLDER", 0, 0, -8000)
module["Hosts"]["crypto-trd"] = newHost("PLACEHOLDER", 0, 0, -10000)
module["Hosts"]["crypto-mn"] = newHost("PLACEHOLDER", 0, 0, -12000)
module["Hosts"]["dent"] = newHost("PLACEHOLDER", 0, 0, -14000)
module["Hosts"]["glisten-gw"] = newHost("PLACEHOLDER", 0, 0, -16000)
module["Hosts"]["glisten-mn"] = newHost("PLACEHOLDER", 0, 0, -18000)
module["Hosts"]["tx-sat"] = newHost("PLACEHOLDER", 0, 0, -20000)
module["Hosts"]["ajax"] = newHost("PLACEHOLDER", 0, 0, -22000)
module["Hosts"]["xjax"] = newHost("PLACEHOLDER", 0, 0, -24000)
module["Hosts"]["document"] = newHost("PLACEHOLDER", 0, 0, -26000)
module["Hosts"]["quokka"] = newHost("PLACEHOLDER", 0, 0, -28000)
module["Hosts"]["quokka-gw"] = newHost("PLACEHOLDER", 0, 0, -30000)
module["Hosts"]["quokka-hq"] = newHost("PLACEHOLDER", 0, 0, -32000)
module["Hosts"]["quokka-pub"] = newHost("PLACEHOLDER", 0, 0, -34000)
module["Hosts"]["quokka-stcm"] = newHost("PLACEHOLDER", 0, 0, -36000)
module["Hosts"]["quokka-sub1"] = newHost("PLACEHOLDER", 0, 0, -38000)
module["Hosts"]["quokka-sub2"] = newHost("PLACEHOLDER", 0, 0, -40000)
module["Hosts"]["quokka-sub3"] = newHost("PLACEHOLDER", 0, 0, -42000)
module["Hosts"]["quokka-ent"] = newHost("PLACEHOLDER", 0, 0, -44000)
module["Hosts"]["ndtf-misc"] = newHost("PLACEHOLDER", 0, 0, -46000)
module["Hosts"]["ndtf-dmp"] = newHost("PLACEHOLDER", 0, 0, -48000)
module["Hosts"]["ndtf-mail"] = newHost("PLACEHOLDER", 0, 0, -50000)
module["Hosts"]["ndtf-wgun"] = newHost("PLACEHOLDER", 0, 0, -52000)
module["Hosts"]["ndtf-aiwg"] = newHost("PLACEHOLDER", 0, 0, -54000)
module["Hosts"]["ndtf-nwg"] = newHost("PLACEHOLDER", 0, 0, -56000)
module["Hosts"]["res-ai"] = newHost("PLACEHOLDER", 0, 0, -58000)
module["Hosts"]["telnet"] = newHost("PLACEHOLDER", 0, 0, -60000)
module["Hosts"]["ndtf-sec"] = newHost("PLACEHOLDER", 0, 0, -62000)
module["Hosts"]["quokka-sec"] = newHost("PLACEHOLDER", 0, 0, -64000)
module["Hosts"]["telnet-mkt"] = newHost("PLACEHOLDER", 0, 0, -68000)
module["Hosts"]["linux"] = newHost("PLACEHOLDER", 0, 0, -70000)
module["Hosts"]["linux-disc"] = newHost("PLACEHOLDER", 0, 0, -72000)
module["Hosts"]["linux-dmp"] = newHost("PLACEHOLDER", 0, 0, -74000)
module["Hosts"]["linux-pub"] = newHost("PLACEHOLDER", 0, 0, -76000)
module["Hosts"]["htmco"] = newHost("PLACEHOLDER", 0, 0, -78000)
module["Hosts"]["ndtf-w3c-htm"] = newHost("PLACEHOLDER", 0, 0, -80000)
module["Hosts"]["rfc-pub"] = newHost("PLACEHOLDER", 0, 0, -82000)
module["Hosts"]["ephmco"] = newHost("PLACEHOLDER", 0, 0, -84000)
module["Hosts"]["ephmco-pub"] = newHost("PLACEHOLDER", 0, 0, -86000)
module["Hosts"]["ephmco-disc"] = newHost("PLACEHOLDER", 0, 0, -88000)
module["Hosts"]["ndtf-discstcm"] = newHost("PLACEHOLDER", 0, 0, -90000)
module["Hosts"]["guidance"] = newHost("PLACEHOLDER", 0, 0, -92000)
module["Hosts"]["gluttony"] = newHost("PLACEHOLDER", 0, 0, -94000)
module["Hosts"]["gluttony-mn"] = newHost("PLACEHOLDER", 0, 0, -96000)
module["Hosts"]["key"] = newHost("PLACEHOLDER", 0, 0, -98000)
module["Hosts"]["msc"] = newHost("PLACEHOLDER", 0, 0, -10000)
module["Hosts"]["betrayal"] = newHost("PLACEHOLDER", 0, 2000, 0)
module["Hosts"]["min-host"] = newHost("PLACEHOLDER", 0, 2000, 2000)
module["Hosts"]["hostserv"] = newHost("PLACEHOLDER", 0, 2000, 4000)
module["Hosts"]["uninet"] = newHost("PLACEHOLDER", 0, 2000, 6000)
module["Hosts"]["unitools"] = newHost("PLACEHOLDER", 0, 2000, 8000)
module["Hosts"]["void"] = newHost("PLACEHOLDER", 0, 2000, 10000)
module["Hosts"]["voidtech"] = newHost("PLACEHOLDER", 0, 2000, 12000)
module["Hosts"]["voidtech-web"] = newHost("PLACEHOLDER", 0, 2000, 14000)
module["Hosts"]["voidtech-mn"] = newHost("PLACEHOLDER", 0, 2000, 16000)
module["Hosts"]["voidtech-queries"] = newHost("PLACEHOLDER", 0, 2000, 18000)
module["Hosts"]["voidtech-marketing"] = newHost("PLACEHOLDER", 0, 2000, 20000)
module["Hosts"]["voidtech-satcom"] = newHost("PLACEHOLDER", 0, 2000, 22000)
module["Hosts"]["voidtech-gw1"] = newHost("PLACEHOLDER", 0, 2000, 24000)
module["Hosts"]["voidtech-gw2"] = newHost("PLACEHOLDER", 0, 2000, 26000)
module["Hosts"]["voidtech-disc1"] = newHost("PLACEHOLDER", 0, 2000, 28000)
module["Hosts"]["voidtech-disc2"] = newHost("PLACEHOLDER", 0, 2000, 30000)
module["Hosts"]["voidtech-disc3"] = newHost("PLACEHOLDER", 0, 2000, 32000)
module["Hosts"]["voidtech-lnk"] = newHost("PLACEHOLDER", 0, 2000, 34000)
module["Hosts"]["voidtech-dmp"] = newHost("PLACEHOLDER", 0, 2000, 36000)
module["Hosts"]["voidtech-docs"] = newHost("PLACEHOLDER", 0, 2000, 38000)
module["Hosts"]["fibreglass"] = newHost("PLACEHOLDER", 0, 2000, 40000)
module["Hosts"]["netmon"] = newHost("PLACEHOLDER", 0, 2000, 42000)
module["Hosts"]["sys05"] = newHost("PLACEHOLDER", 0, 2000, 44000)
module["Hosts"]["x24x"] = newHost("PLACEHOLDER", 0, 2000, 46000)
module["Hosts"]["1337co"] = newHost("PLACEHOLDER", 0, 2000, 48000)
module["Hosts"]["org31173"] = newHost("PLACEHOLDER", 0, 2000, 50000)
module["Hosts"]["doc37n"] = newHost("PLACEHOLDER", 0, 2000, 52000)
module["Hosts"]["castle"] = newHost("PLACEHOLDER", 0, 2000, 54000)
module["Hosts"]["mininet"] = newHost("PLACEHOLDER", 0, 2000, 56000)
module["Hosts"]["q1"] = newHost("PLACEHOLDER", 0, 2000, 58000)

-- Graph representing the hosts and their connections
module["Graph"] = {
	voidhome = {"voidtech-gw1", "sys05", "doc37n", "res-1", "water"}
}

--- General function to get the host object from the hostname.
function module.getHostFromName(name: string)
	return module[name]
end

--- Function to get the map name of the host.
function module.getMap(host: string): string
	return module[host]:getMap()
end

function module.hostIsNextTo(origin: string, target: string)
	local adjacentHosts = module["Graph"][origin]

	if utils.linearSearch(adjacentHosts, target) == -1 then
		return false
	else
		return true
	end
end

function module.pathToHost(origin: string, target: string)
	return utils.shortestUnweightedPath(module.Hosts, origin, target)
end

type DimensionTable = {bottomleft: Vector3, bottomright: Vector3, topleft: Vector3, topright: Vector3}

--- Returns the X, Y and Z dimensions of the 4 corners of the host in their respective order
function module.getHostDimensions(hostname: string): DimensionTable
	local hostData = module["Hosts"][hostname]
	local y = HALF_HOST_SIZE

	return {
		bottomleft = Vector3.new(
			hostData.x - HALF_HOST_SIZE,
			y,
			hostData.z - HALF_HOST_SIZE
		),
		bottomright = Vector3.new(
			hostData.x + HALF_HOST_SIZE,
			y,
			hostData.z - HALF_HOST_SIZE
		),
		topleft = Vector3.new(
			hostData.x - HALF_HOST_SIZE,
			y,
			hostData.z + HALF_HOST_SIZE
		),
		topright = Vector3.new(
			hostData.x + HALF_HOST_SIZE,
			y,
			hostData.z + HALF_HOST_SIZE
		)
	}
end

return module