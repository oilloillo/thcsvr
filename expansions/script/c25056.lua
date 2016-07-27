--毒符『甜蜜毒素』
function c25056.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c25056.acon)
	e1:SetOperation(c25056.activate)
	c:RegisterEffect(e1)
	--todeck
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetOperation(c25056.acr)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c25056.condition)
	e3:SetTarget(c25056.target)
	e3:SetOperation(c25056.operation)
	c:RegisterEffect(e3)
end
function c25056.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x165)
end
function c25056.acon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c25056.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c25056.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c25056.damval)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_REVERSE_RECOVER)
	e2:SetTargetRange(0,1)
	e2:SetValue(1)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	Duel.RegisterEffect(e2,tp)
end
function c25056.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0
	else return val end
end
function c25056.acr(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if bit.band(r,0x40)~=0x40 or c:GetReasonPlayer()==tp then return end
	c:RegisterFlagEffect(25056,RESET_EVENT+0x1fe0000,0,0)
end
function c25056.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()==PHASE_MAIN1 and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c25056.filter(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function c25056.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(25056)>0 and e:GetHandler():IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c25056.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),2,0,0)
end
function c25056.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c25056.filter,tp,0,LOCATION_MZONE,nil)
	if e:GetHandler():IsRelateToEffect(e) and g:GetCount()>0 then
		local tg=g:GetMaxGroup(Card.GetAttack)
		local atk=tg:GetFirst():GetAttack()
		tg:AddCard(e:GetHandler())
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
		Duel.Recover(tp,atk,REASON_EFFECT)
		Duel.Recover(1-tp,atk,REASON_EFFECT)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetTargetRange(0,1)
		Duel.RegisterEffect(e2,tp)
	end
end
