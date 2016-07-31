 
--紧急回避结界
function c200304.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c200304.condition)
	e1:SetTarget(c200304.target)
	e1:SetOperation(c200304.activate)
	c:RegisterEffect(e1)
end
function c200304.filter(c,tp)
	return c:IsLocation(LOCATION_ONFIELD) and c:GetControler()==tp
end
function c200304.condition(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c200304.filter,1,nil,tp) and Duel.IsChainNegatable(ev) 
	and Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x700)>0
end
function c200304.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c200304.cfilter(c,tp)
	return c:GetCounter(0x700)>0
end
function c200304.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x700)==0 then return end
	local g=Duel.GetMatchingGroup(c200304.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local tc=g:GetFirst()
	while tc do
		local sct=tc:GetCounter(0x700)
		tc:RemoveCounter(tp,0x700,sct,0)
		tc=g:GetNext()
	end
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end