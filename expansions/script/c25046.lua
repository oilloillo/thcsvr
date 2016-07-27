--毒符『神经麻痹毒』
function c25046.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e1:SetCost(c25046.cost)
	e1:SetOperation(c25046.activate)
	c:RegisterEffect(e1)
end
function c25046.filter(c)
	return math.abs(c:GetAttack()-c:GetDefence())==200 or math.abs(c:GetAttack()-c:GetDefence())==2000
end
function c25046.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c25046.filter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c25046.filter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c25046.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetTurnCounter(0)
	c:RegisterFlagEffect(25046,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetOperation(c25046.damop)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	e3:SetOperation(c25046.operation)
	Duel.RegisterEffect(e3,tp)
	local e1=e3:Clone()
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e1,tp)
end
function c25046.damop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then return end
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	if(ct<3) then
		ct=ct+1
		c:SetTurnCounter(ct)
	end
end
function c25046.tpfilter(c,tp)
	return c:GetSummonPlayer()~=tp
end
function c25046.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c25046.tpfilter,nil,tp)
	if g:GetCount()==0 then return end
	local dice=Duel.TossDice(tp,1)
	if dice==1 or dice==4 then
		Duel.Damage(1-tp,700,REASON_EFFECT)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetLabelObject(e:GetHandler())
			e1:SetCondition(c25046.condition)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end
end
function c25046.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(25046)>0
end
