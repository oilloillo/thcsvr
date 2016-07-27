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
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c10051.drop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e4=Effect.CreateEffect(e:GetHandler())
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
function c10051.drop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c10051.filter,1,nil,1-tp) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c10051.desop(e,tp,eg,ep,ev,re,r,rp)
	local gc=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if gc>0 and hg:GetCount()>0 then
		local sg=hg:FilterSelect(tp,Card.IsAbleToGrave,gc,gc,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
