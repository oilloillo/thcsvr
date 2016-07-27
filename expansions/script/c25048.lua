--毒符『忧郁之毒』
function c25048.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e1:SetCost(c25048.cost)
	e1:SetOperation(c25048.activate)
	c:RegisterEffect(e1)
end
function c25048.filter(c)
	return c:IsSetCard(0x164) and c:IsAbleToGraveAsCost()
end
function c25048.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c25048.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c25048.filter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c25048.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetTurnCounter(0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCondition(c25048.damcon)
	e1:SetOperation(c25048.damop)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN,5)
	Duel.RegisterEffect(e1,tp)
end
function c25048.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c25048.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	if(ct<5) then
		ct=ct+1
		c:SetTurnCounter(ct)
		Duel.Damage(1-tp,400,REASON_EFFECT)
	end
end
