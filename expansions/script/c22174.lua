 
--七曜-金水符「水银之毒」
function c22174.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c22174.con)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22174,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(c22174.acttg)
	e2:SetOperation(c22174.actop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_DECK)
	e3:SetCondition(c22174.actcon)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22174,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c22174.cost)
	e4:SetTarget(c22174.target)
	e4:SetOperation(c22174.operation)
	c:RegisterEffect(e4)
end
function c22174.con(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():GetFlagEffect(22174)==1
end
function c22174.actfilter1(c)
	return c:IsSetCard(0x181) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsFaceup()
end
function c22174.actfilter2(c)
	return c:IsSetCard(0x179) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsFaceup()
end
function c22174.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22174.actfilter1,tp,LOCATION_SZONE,0,1,nil) and 
		Duel.IsExistingMatchingCard(c22174.actfilter2,tp,LOCATION_SZONE,0,1,nil) end
	e:GetHandler():RegisterFlagEffect(22174,RESET_EVENT+0x1fe0000,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c22174.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c22174.actfilter1,tp,LOCATION_SZONE,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c22174.actfilter2,tp,LOCATION_SZONE,0,1,1,nil)
	g1:Merge(g2)
		if Duel.SendtoGrave(g1,REASON_MATERIAL)~=0 then
			if not e:GetHandler():GetActivateEffect():IsActivatable(tp) then return end
			Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	Duel.RaiseEvent(e:GetHandler(),EVENT_CHAIN_SOLVED,e:GetHandler():GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
end
function c22174.dactfilter(c)
	return c:IsFaceup() and c:IsCode(22017)
end
function c22174.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22174.dactfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22174.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) and e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	Duel.PayLPCost(tp,500)
end
function c22174.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c22174.operation(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetReset(RESET_PHASE+PHASE_END,8)
	e2:SetCondition(c22174.damcon)
	e2:SetOperation(c22174.damop)
	Duel.RegisterEffect(e2,tp)
end
function c22174.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c22174.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,888174)
	Duel.Damage(1-tp,1100,REASON_EFFECT)
end
