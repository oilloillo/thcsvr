--巫女小姐✿博丽灵梦
function c11036.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11036,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c11036.cost)
	e1:SetTarget(c11036.target)
	e1:SetOperation(c11036.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11036,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c11036.spcost)
	e2:SetTarget(c11036.target)
	e2:SetOperation(c11036.spop)
	c:RegisterEffect(e2)
end
function c11036.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c11036.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
function c11036.operation(e,tp,eg,ep,ev,re,r,rp)
	--cannot act
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c11036.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c11036.aclimit(e,re,tp)
	return re:GetHandler():GetLocation()==LOCATION_REMOVED or re:GetHandler():GetLocation()==LOCATION_HAND
end
function c11036.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c11036.spop(e,tp,eg,ep,ev,re,r,rp)
	--cannot remove
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
