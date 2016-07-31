 
--七曜-土水符「诺亚的大洪水」
function c888172.initial_effect(c)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(888172,1))
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	--e4:SetCost(c888172.cost)
	e4:SetTarget(c888172.target)
	e4:SetOperation(c888172.operation)
	c:RegisterEffect(e4)
end
function c888172.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c888172.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,sg:GetCount(),0,0)
end
function c888172.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
