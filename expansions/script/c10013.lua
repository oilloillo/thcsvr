 
--东·方·千·秋·乐
function c10013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c10013.condition)
	e1:SetTarget(c10013.target)
	e1:SetOperation(c10013.activate)
	c:RegisterEffect(e1)
end
function c10013.cfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c10013.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10013.cfilter,tp,LOCATION_REMOVED,0,1,nil,10009)
		and Duel.IsExistingMatchingCard(c10013.cfilter,tp,LOCATION_REMOVED,0,1,nil,26007)
		and Duel.IsExistingMatchingCard(c10013.cfilter,tp,LOCATION_REMOVED,0,1,nil,26018)
		and Duel.IsExistingMatchingCard(c10013.cfilter,tp,LOCATION_REMOVED,0,1,nil,20044)
end
function c10013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
function c10013.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Win(tp,0x21)
end
