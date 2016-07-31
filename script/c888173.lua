 
--七曜-土金符「翡翠巨石」
function c888173.initial_effect(c)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(888173,1))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetTarget(c888173.target)
	e4:SetOperation(c888173.operation)
	c:RegisterEffect(e4)
end
function c888173.filter1(c)
	return c:IsPosition(POS_ATTACK)
end
function c888173.filter2(c)
	return c:IsPosition(POS_DEFENCE)
end
function c888173.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local g1=Duel.GetMatchingGroup(c888173.filter2,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(c888173.filter1,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g2,g2:GetCount(),0,0)
end
function c888173.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c888173.filter2,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g1,REASON_EFFECT)
	local g2=Duel.GetMatchingGroup(c888173.filter1,tp,0,LOCATION_MZONE,nil)
	Duel.ChangePosition(g2,POS_FACEUP_DEFENCE)
end
