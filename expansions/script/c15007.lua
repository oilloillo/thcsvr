 
--魔界公主 爱丽丝
function c15007.initial_effect(c)
	--immune effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(c15007.indcon)
	e1:SetValue(c15007.efilter)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(15007,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCost(c15007.cost)
	e2:SetTarget(c15007.target)
	e2:SetOperation(c15007.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--negate spell
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(15007,1))
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c15007.negcon)
	e5:SetCost(c15007.cost)
	e5:SetTarget(c15007.negtg)
	e5:SetOperation(c15007.negop)
	c:RegisterEffect(e5)
end
function c15007.infilter(c)
	return c:IsSetCard(0x150) and c:IsFaceup()
end
function c15007.indcon(e)
	return Duel.IsExistingMatchingCard(c15007.infilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c15007.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER)
end
function c15007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fa=Duel.GetFlagEffect(tp,15000)
	local fb=Duel.GetFlagEffect(tp,150000)
	local fc=fa-fb
	if chk==0 then return fc<3 end
	Duel.RegisterFlagEffect(tp,15000,RESET_PHASE+PHASE_END,0,1)
end
function c15007.filter(c)
	return c:IsCode(15050) and c:IsAbleToHand()
end
function c15007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c15007.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetChainLimit(aux.FALSE)
end
function c15007.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstMatchingCard(c15007.filter,tp,LOCATION_DECK,0,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c15007.negcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return Duel.GetTurnPlayer()==tp and ep~=tp and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c15007.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c15007.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
