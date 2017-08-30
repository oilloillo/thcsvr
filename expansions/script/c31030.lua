--星条旗的小丑✿克劳恩皮丝
function c31030.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x208),4,2,c31030.ovfilter,aux.Stringid(31030,2),2,c31030.xyzop)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(31030,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c31030.condition)
	e1:SetCost(c31030.cost)
	e1:SetTarget(c31030.target)
	e1:SetOperation(c31030.operation)
	c:RegisterEffect(e1)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(31030,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c31030.descon)
	e3:SetTarget(c31030.destg)
	e3:SetOperation(c31030.desop)
	c:RegisterEffect(e3)
end
function c31030.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x275)
end
function c31030.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c31030.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c31030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c31030.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c31030.dfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsSetCard(0x275)
end
function c31030.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ag=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=ag:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(500)
		tc:RegisterEffect(e1)
		tc=ag:GetNext()
	end
	local g=Duel.GetMatchingGroup(c31030.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function c31030.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetOverlayCount()~=0
end
function c31030.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsDisabled() and c:IsDestructable()
end
function c31030.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c31030.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c31030.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c31030.filter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(tp,1)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
