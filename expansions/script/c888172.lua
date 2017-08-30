 --七曜-土水符「诺亚的大洪水」
function c888172.initial_effect(c)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(888172,1))
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetTarget(c888172.target)
	e4:SetOperation(c888172.operation)
	c:RegisterEffect(e4)
end
function c888172.filter(c)
	return not (c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_WATER))
end
function c888172.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c888172.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c888172.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,sg:GetCount(),0,0)
end
function c888172.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c888172.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
