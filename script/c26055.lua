 
--溺符「陷落漩涡」
function c26055.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c26055.condition)
	e1:SetCost(c26055.cost)
	e1:SetTarget(c26055.target)
	e1:SetOperation(c26055.activate)
	c:RegisterEffect(e1)
end
function c26055.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_ZOMBIE)
end
function c26055.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev)
		and (re:IsActiveType(TYPE_MONSTER) or (re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)))
end
function c26055.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c26055.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c26055.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c26055.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c26055.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
