--狼符『狂血断噬』
function c23144.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c23144.cost)
	e1:SetTarget(c23144.target)
	e1:SetOperation(c23144.activate)
	c:RegisterEffect(e1)
end
function c23144.filter(c)
	return c:IsCode(23137) and c:IsAbleToRemoveAsCost()
end
function c23144.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23144.filter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c23144.filter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c23144.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c23144.atkfilter(c)
	return c:IsSetCard(0x824) and c:IsFaceup()
end
function c23144.activate(e,tp,eg,ep,ev,re,r,rp)
	--atkup
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetOperation(c23144.atkop)
	Duel.RegisterEffect(e2,tp)
end
function c23144.atkop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
    local g=Duel.GetMatchingGroup(atkfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ev)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
