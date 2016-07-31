 
--ÚÁ·Ã´óÕ½
function c23005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c23005.condition)
	e1:SetCost(c23005.cost)
	e1:SetTarget(c23005.target)
	e1:SetOperation(c23005.activate)
	c:RegisterEffect(e1)
end
function c23005.cfilter(c)
	return c:IsFaceup() and (c:IsCode(23009) or c:IsCode(23010))
end
function c23005.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c23005.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c23005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,Duel.GetLP(tp)/2)
end
function c23005.filter(c)
	return not (c:IsCode(23009) or c:IsCode(23010)) and c:IsDestructable()
end
function c23005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23005.filter,tp,0xe,0xe,1,nil) end
	local g=Duel.GetMatchingGroup(c23005.filter,tp,0xe,0xe,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c23005.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c23005.filter,tp,0xe,0xe,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
