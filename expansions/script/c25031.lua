 
--寂静气旋
function c25031.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c25031.condition)
	e1:SetCost(c25031.cost)
	e1:SetOperation(c25031.operation)
	c:RegisterEffect(e1)
end
function c25031.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c25031.cfilter(c)
	return (c:IsSetCard(0x999) or c:GetOriginalCode()==(90019)) and c:IsDiscardable()
end
function c25031.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c25031.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c25031.cfilter,1,1,REASON_COST+REASON_DISCARD)
	Duel.SetChainLimit(aux.FALSE)
end
function c25031.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,c)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
		tc=g:GetNext()
	end
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetTargetRange(0,1)
	e4:SetValue(c25031.aclimit)
	e4:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e4,tp)
end
function c25031.aclimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER)
end
