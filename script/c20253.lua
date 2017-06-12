--魂魄行者✿衍生物
function c20253.initial_effect(c)
	local argTable = {1}
	Nef.EnablePendulumAttributeSP(c,c20253.tpii,aux.TRUE,argTable)
	Nef.SetPendExTarget(c,c20253.pendfilter)
end
function c20253.cfilter(c)
	return c:IsType(TYPE_TOKEN) and c:IsRace(RACE_ZOMBIE)
end
function c20253.tpii(c)
	return Duel.GetMatchingGroupCount(c20253.cfilter,c:GetControler(),LOCATION_MZONE,0,nil)
end
function c20253.pendfilter(c)
	local tp = c:GetControler()
	return Duel.GetMatchingGroup(aux.TRUE, tp, 0x30, 0, nil)
end
