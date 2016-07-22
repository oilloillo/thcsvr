--谵妄『进入疯狂』
function c25051.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e1:SetCost(c25051.cost)
	e1:SetOperation(c25051.activate)
	c:RegisterEffect(e1)
end
function c25051.filter(c)
	return c:IsSetCard(0x164) and c:IsAbleToRemoveAsCost()
end
function c25051.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c25051.filter,tp,0x1c,0,4,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c25051.filter,tp,0x1c,0,4,4,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c25051.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetTurnCounter(0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCondition(c25051.damcon)
	e1:SetOperation(c25051.damop)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,5)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCondition(c25051.damcon)
	e2:SetOperation(c25051.count)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,5)
	Duel.RegisterEffect(e2,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetTargetRange(0,1)
	e4:SetValue(1)
	e4:SetCondition(c25051.condition)
	e4:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,5)
	Duel.RegisterEffect(e4,tp)
end
function c25051.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c25051.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,25051)
	Duel.Damage(1-tp,500,REASON_EFFECT)
end
function c25051.count(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	if(ct<5) then
		ct=ct+1
		c:SetTurnCounter(ct)
	end
end
function c25051.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1
end
