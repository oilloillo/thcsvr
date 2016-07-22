--毒符「蛛毒」
function c24047.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e1:SetTarget(c24047.atg)
	e1:SetOperation(c24047.activate)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CHAIN_UNIQUE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c24047.condition)
	e2:SetTarget(c24047.target)
	e2:SetOperation(c24047.operation)
	c:RegisterEffect(e2)
end
function c24047.cfilter(c)
	return c:IsFaceup() and (c:IsCode(24004) or c:IsCode(24044)) 
end
function c24047.atg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24047.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)
end
function c24047.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>=2 and Duel.IsChainDisablable(0) and Duel.SelectYesNo(1-tp,aux.Stringid(24047,0)) then
		local g=Duel.SelectMatchingCard(1-tp,aux.TRUE,tp,0,LOCATION_HAND,2,2,nil)
		Duel.SendtoGrave(g,REASON_EFFECT)
	else
		Duel.Damage(1-tp,300,REASON_EFFECT)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCountLimit(1)
		e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e2:SetOperation(c24047.damop)
		Duel.RegisterEffect(e2,tp)
	end
end
function c24047.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,24047)
	Duel.Damage(1-tp,300,REASON_EFFECT)
end
function c24047.gfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK) and not c:IsReason(REASON_DRAW)
end
function c24047.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and eg:IsExists(c24047.gfilter,1,nil,1-tp) and c:IsAbleToDeck() and not c:IsStatus(STATUS_CHAINING)
end
function c24047.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c24047.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetTargetRange(0,1)
		Duel.RegisterEffect(e2,tp)
	end
end
