--魂魄行者✿衍生物
function c20253.initial_effect(c)
	local argTable = {1}
	local ct=Duel.GetMatchingGroupCount(c20253.cfilter,c:GetControler(),LOCATION_MZONE,0,nil)
	Nef.EnablePendulumAttributeSP(c,ct,aux.TRUE,argTable)
	Nef.SetPendExTarget(c,c20253.pendfilter)
end
function c20253.cfilter(c)
	return c:IsType(TYPE_TOKEN) and c:IsRace(RACE_ZOMBIE)
end
function c20253.filter(c)
	return c:IsSetCard(0x999) and (c:IsAttribute(ATTRIBUTE_WATER) or c:IsAttribute(ATTRIBUTE_LIGHT)) and c:IsFaceup()
end
function c20253.pendfilter(c)
	local tp = c:GetControler()
	return Duel.GetMatchingGroup(c20253.filter, tp, 0x30, 0, nil)
end
