 
--八云一家
function c20059.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c20059.condition)
	e1:SetTarget(c20059.target)
	e1:SetOperation(c20059.activate)
	c:RegisterEffect(e1)
end
function c20059.cfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c20059.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c20059.cfilter,tp,LOCATION_MZONE,0,1,nil,20003)
		and Duel.IsExistingMatchingCard(c20059.cfilter,tp,LOCATION_MZONE,0,1,nil,20035)
		and Duel.IsExistingMatchingCard(c20059.cfilter,tp,LOCATION_MZONE,0,1,nil,20038)
end
function c20059.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c20059.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end