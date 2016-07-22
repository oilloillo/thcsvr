--龙符「龙之低吼」
function c210015.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e1:SetDescription(aux.Stringid(210015,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c210015.condition)
	e1:SetTarget(c210015.target)
	e1:SetOperation(c210015.activate)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e1:SetDescription(aux.Stringid(210015,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c210015.condition2)
	e1:SetTarget(c210015.target2)
	e1:SetOperation(c210015.activate2)
	c:RegisterEffect(e1)
end
function c210015.cfilter(c)
	return c:IsSetCard(0x710) and c:IsFaceup()
end
function c210015.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.IsExistingMatchingCard(c210015.cfilter,tp,LOCATION_ONFIELD,0,1,nil) 
	and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c210015.filter(c)
	return c:IsType(TYPE_SPELL) and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and c:IsFaceup()
end
function c210015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c210015.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0) end
end
function c210015.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c210015.filter,tp,LOCATION_ONFIELD,0,1,1,nil):GetFirst()
	if not tc then return end
	Duel.SendtoGrave(tc,REASON_EFFECT)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c210015.condition2(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.IsExistingMatchingCard(c210015.cfilter,tp,LOCATION_ONFIELD,0,1,nil) 
	and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c210015.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c210015.filter,tp,LOCATION_ONFIELD,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0) end
end
function c210015.activate2(e,tp,eg,ep,ev,re,r,rp)
	local m=Duel.GetMatchingGroupCount(c210015.filter,tp,LOCATION_ONFIELD,0,nil)
	if m<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c210015.filter,tp,LOCATION_ONFIELD,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end