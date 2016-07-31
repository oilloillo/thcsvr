 
--漂溺「光辉水底的心伤」
function c23045.initial_effect(c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c23045.target)
	e1:SetOperation(c23045.operation)
	c:RegisterEffect(e1)
end
function c23045.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x817)
end
function c23045.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23045.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c23045.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c23045.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(c23045.efilter)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DIRECT_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetOperation(c23045.resetop)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetLabelObject(e3)
	Duel.RegisterEffect(e4,tp)
end
function c23045.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer() and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c23045.resetop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and re:GetHandler():GetTurnID()==Duel.GetTurnCount() then
		e:GetLabelObject():Reset()
		e:Reset()
	end
end
