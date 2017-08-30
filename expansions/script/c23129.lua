--九天之狼牙✿犬走椛
function c23129.initial_effect(c)
	--synchro summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x208),4,3)
	c:EnableReviveLimit()
	--destrakup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23129,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c23129.condition)
	e1:SetCost(c23129.cost)
	e1:SetTarget(c23129.target)
	e1:SetOperation(c23129.operation)
	c:RegisterEffect(e1)
	--multi attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(23129,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c23129.atkcon)
	e3:SetCost(c23129.cost)
	e3:SetTarget(c23129.atktg)
	e3:SetOperation(c23129.atkop)
	c:RegisterEffect(e3)
end
function c23129.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c23129.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c23129.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c23129.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	-- Duel.Destroy(g,REASON_EFFECT)
	-- local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_GRAVE+LOCATION_REMOVED)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(ct*300)
		e:GetHandler():RegisterEffect(e1)
	end
end
function c23129.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c23129.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK)==0 end
end
function c23129.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
