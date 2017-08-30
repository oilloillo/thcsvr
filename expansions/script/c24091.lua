--大家的心病✿古明地觉-废狱
function c24091.initial_effect(c)
	--public
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24091,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c24091.pcon)
	e1:SetCost(c24091.pcost)
	e1:SetTarget(c24091.ptg)
	e1:SetOperation(c24091.pop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24091,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c24091.discon)
	e2:SetCost(c24091.discost)
	e2:SetTarget(c24091.distg)
	e2:SetOperation(c24091.disop)
	c:RegisterEffect(e2)
end
function c24091.pcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c24091.pcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c24091.pfilter(c)
	return not c:IsPublic()
end
function c24091.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24091.pfilter,tp,0,LOCATION_HAND,1,nil) end
end
function c24091.pop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.ConfirmCards(tp,g)
	Duel.ShuffleHand(1-tp)
end
function c24091.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) 
end
function c24091.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.Release(e:GetHandler(),REASON_COST)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c24091.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c24091.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end