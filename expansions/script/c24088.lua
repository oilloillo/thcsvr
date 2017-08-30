--怨灵也为之惧怯的少女✿古明地觉
function c24088.initial_effect(c)
	--public
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24088,0))
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c24088.pcon)
	e1:SetCost(c24088.pcost)
	e1:SetTarget(c24088.ptg)
	e1:SetOperation(c24088.pop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24088,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c24088.discon)
	e2:SetTarget(c24088.distg)
	e2:SetOperation(c24088.disop)
	c:RegisterEffect(e2)
end
function c24088.pcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c24088.pcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c24088.pfilter(c)
	return not c:IsPublic()
end
function c24088.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24088.pfilter,tp,0,LOCATION_HAND,1,nil) end
end
function c24088.pop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c24088.pfilter,tp,0,LOCATION_HAND,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c24088.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) 
		and re:GetHandler():GetLevel()>0 and re:GetHandler():GetLevel()<=e:GetHandler():GetLevel()
end
function c24088.disfilter(c)
	return c:IsAbleToGrave() and c:IsSetCard(0x625)
end
function c24088.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24088.disfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c24088.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c24088.disfilter,tp,LOCATION_HAND,0,1,nil) then 
		Duel.NegateActivation(ev)
		local g=Duel.SelectMatchingCard(tp,c24088.disfilter,tp,LOCATION_HAND,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
