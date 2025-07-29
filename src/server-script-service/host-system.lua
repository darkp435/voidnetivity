--[[
 Copyright 2025 Tiger Duan

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

--[[
Module for managing the host system and abstracting it as well as fetching data about the host
Host system is represented via a graph because it aligns better with what the network looks like
]]

local module = {}

-- Host class
Host = {}
Host.__index = Host

function Host.new(map, x, y, z)
	local self = setmetatable({}, Host)
	self.map = map
	self.x = x
	self.y = y
	self.z = z
	return self
end

function Host:getVector3()
	return Vector3.new(self.x, self.y, self.z)
end

function Host:getCFrame()
	return CFrame.new(self.x, self.y, self.z)
end

function Host:getMap()
	return self.map
end

-- hostnames will be represented via an adjacency list, then converted to objects for convenience, pseudocode:
--[[

module {
	hostname: {"edge1", "edge2", ...}
	...
}

]]

--[[
list of hostnames:

water
ndtf
ndtf-wg1
ndtf-wg2
ndtf-w3c
ndtf-ise
ndtf-iseg
lemon
lemon-ade
grass
silicon-net
pixel435
pixel435
sub-ndtf
ndtf-satcom
gubby
voidnetivate (home)
jerseysoft
jerseysoft-satcom
jerseylabs
jerseysoft-mn
jerseysoft-gw
jerseysoft-hq
ndtflabs
boxy
restmain
intl
asynco
ndtf-rfc
prop
mocha
seren-co
little
franksoft
res-1
res-2
res-3
res-4
res-5
unires
love
trust
toxicate-ent
toxicate-mn
toxicate-sub1
toxicate-sub2
toxicate-satcom
toxicate-gw
ndtf-gw
darkn
crypto-gw
crypto-ent
crypto-stcm
crypto-trd
crypto-mn
dent
glisten-gw
glisten-mn
tx-sat
ajax
xjax
document
quokka
quokka-gw
quokka-hq
quokka-pub
quokka-stcm
quokka-sub1
quokka-sub2
quokka-sub3
quokka-ent
ndtf-misc
ndtf-dmp
ndtf-mail
ndtf-wgun
ndtf-aiwg
ndtf-nwg
res-ai
telnet
ndtf-sec
quokka-sec
telnet-mkt
linux
linux-disc
linux-dmp
linux-pub
htmco
ndtf-w3c-htm
rfc-pub
ephmco
ephmco-pub
ephmco-disc
ndtf-discstcm
guidance
gluttony
gluttony-mn
key
msc
betrayal
min-host
hostserv
uninet
unitools
void
voidtech
voidtech-web
voidtech-mn
voidtech-queries
voidtech-marketing
voidtech-satcom
voidtech-gw1
voidtech-gw2
voidtech-disc1
voidtech-disc2
voidtech-disc3
voidtech-lnk
voidtech-dmp
voidtec-docs
fibreglass
netmon
sys05
x24x
1337co
org31173
doc37n
castle
mininet
q1

graph is directed and unweighted
adjacency list (should be able to copy into file seamlessly):

{
    voidnetivate: {"voidtech-gw1", "sys05", "doc37n", "res-1", "water"}
}
]]
module["foo"] = Host.new("Map2", 13123, 4, 1)
module["bar"] = Host.new("Map2", 2324, 123, 4354)

--- General function to get the host object from the hostname.
function module.getHostFromName(name: string): table
	return module[name]
end

--- Function to get the map name of the host.
function module.getMap(host: string): string
	return module[host]:getMap()
end

return module

