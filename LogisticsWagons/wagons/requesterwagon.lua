-- passive logistics wagon
local class = require 'middleclass'

RequesterWagon = class('RequesterWagon',ProxyWagon)

function RequesterWagon:initialize(parent,data)
	debugLog("RequesterWagon:initialize")
	ProxyWagon.initialize(self, parent, data)
	self.wagonType = "RequesterWagon"
	
	if(data ~= nil) then
		debugLog("Need to check the requester slots")
	else
		self.requestSlots = {}
	end
end

function RequesterWagon:updateWagon(tick)
	ProxyWagon.updateWagon(self,tick)
end

function RequesterWagon:updateDataSerialisation()
	ProxyWagon.updateDataSerialisation(self)
	
	self:updateRequestSlots()
	
	self.data.requestSlots = self.requestSlots
end

function RequesterWagon:createProxyType()
	local proxyType = "lw-logistic-chest-requester-trans"
	self:createProxy(proxyType)
end

function RequesterWagon:createProxy(proxyType)
	ProxyWagon.createProxy(self,proxyType,true)
	
	self:setRequestSlots()
end

function RequesterWagon:updateRequestSlots()
	if self.proxy ~= nil then
		local i = 0
		local slots = {}
		while i < 10 do
			i = i + 1
			
			slots[i] = self.proxy.getrequestslot(i)
			if slots[i] == nil then
				slots[i] = {}
			end
		end
		self.requestSlots = slots
	end
end

function RequesterWagon:setRequestSlots()
	if self.proxy ~= nil and self.requestSlots ~= {} then
		local i = 0
		local slots = {}
		while i < 10 do
			i = i + 1
			
			if slots[i] == nil or slots[i] == {} then
				self.proxy.clearrequestslot(i)				
			else
				self.proxy.setrequestslot(i, slots[i])				
			end
		end
		self.requestSlots = slots
	end
end
