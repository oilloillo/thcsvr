--月光妖精☆露娜✿查尔德
--require "expansions/nef/nef"
function c999503.initial_effect(c)
	local argTable = {1}
	Nef.EnablePendulumAttributeSP(c,3,aux.TRUE,argTable)
	Nef.SetPendExTarget(c, c999503.pendfilter)
end

function c999503.filter(c)
	return c:IsSetCard(0x999) and (c:IsAttribute(ATTRIBUTE_FIRE) or c:IsAttribute(ATTRIBUTE_WATER))
end

function c999503.pendfilter(c)
	local tp = c:GetControler()
	return Duel.GetMatchingGroup(c999503.filter, tp, LOCATION_GRAVE, 0, nil)
end