--红与白的巫女✿博丽灵梦
function c10051.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10051,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10051)
	e1:SetCost(c10051.cost)
	e1:SetOperation(c10051.operation)
	c:RegisterEffect(e1)
end
function c10051.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c10051.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c10051.drcon1)
	e1:SetOperation(c10051.drop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--sp_summon effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c10051.regcon)
	e2:SetOperation(c10051.regop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(c10051.drcon2)
	e3:SetOperation(c10051.drop2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetOperation(c10051.desop)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	Duel.RegisterEffect(e4,tp)
end
function c10051.filter(c,sp)
	return c:GetSummonPlayer()==sp
end
function c10051.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10051.filter,1,nil,1-tp) 
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function c10051.drop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c10051.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10051.filter,1,nil,1-tp) 
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c10051.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,10051,RESET_CHAIN,0,1)
end
function c10051.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,10051)>0
end
function c10051.drop2(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,10051)
	Duel.ResetFlagEffect(tp,10051)
	Duel.Draw(tp,n,REASON_EFFECT)
end
function c10051.desop(e,tp,eg,ep,ev,re,r,rp)
	local gc=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	local hg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND,0,nil)
	local ct=math.min(gc,hg:GetCount())
	if ct>0 then
		Duel.Hint(HINT_CARD,0,10051)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local sg=hg:Select(tp,ct,ct,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
