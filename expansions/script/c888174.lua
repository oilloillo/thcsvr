 
--七曜-金水符「水银之毒」
function c888174.initial_effect(c)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(888174,1))
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCost(c888174.cost)
	e4:SetTarget(c888174.target)
	e4:SetOperation(c888174.operation)
	c:RegisterEffect(e4)
end
function c888174.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c888174.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c888174.operation(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetReset(RESET_PHASE+PHASE_END,8)
	e2:SetCondition(c888174.damcon)
	e2:SetOperation(c888174.damop)
	Duel.RegisterEffect(e2,tp)
end
function c888174.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c888174.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,888174)
	Duel.Damage(1-tp,1100,REASON_EFFECT)
end
