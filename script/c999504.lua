--星光妖精☆斯塔✿萨菲雅
--require "expansions/nef/nef"
function c999504.initial_effect(c)
	local argTable = {1}
	Nef.EnablePendulumAttributeSP(c,2,aux.TRUE,argTable)
	Nef.SetPendExTarget(c, c999504.pendfilter)
end

function c999504.filter(c)
	return c:IsSetCard(0x999) and (c:IsAttribute(ATTRIBUTE_FIRE) or c:IsAttribute(ATTRIBUTE_LIGHT))
end

function c999504.pendfilter(c)
	local tp = c:GetControler()
	return Duel.GetMatchingGroup(c999504.filter, tp, LOCATION_DECK, 0, nil)
end