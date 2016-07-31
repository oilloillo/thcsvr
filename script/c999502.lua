--日光妖精☆桑尼✿米尔可
--require "expansions/nef/nef"
function c999502.initial_effect(c)
	local argTable = {1}
	Nef.EnablePendulumAttributeSP(c,3,aux.TRUE,argTable)
	Nef.SetPendExTarget(c, c999502.pendfilter)
end

function c999502.filter(c)
	return c:IsSetCard(0x999) and (c:IsAttribute(ATTRIBUTE_WATER) or c:IsAttribute(ATTRIBUTE_LIGHT)) and c:IsFaceup()
end

function c999502.pendfilter(c)
	local tp = c:GetControler()
	return Duel.GetMatchingGroup(c999502.filter, tp, LOCATION_REMOVED, 0, nil)
end