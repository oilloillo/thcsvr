--毒符「桦黄小町」
function c24059.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e1:SetTarget(c24059.tokentg)
	e1:SetCost(c24059.cost)
	e1:SetOperation(c24059.activate)
	c:RegisterEffect(e1)
end
function c24059.tokentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)+Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if chk==0 then return ct>-1 and Duel.IsPlayerCanSpecialSummonMonster(tp,24064,0,0x208,600,400,1,RACE_INSECT,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct+1,0,0)
end
function c24059.filter(c)
	return math.abs(c:GetAttack()-c:GetDefence())==200 or math.abs(c:GetAttack()-c:GetDefence())==2000
end
function c24059.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c24059.filter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c24059.filter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c24059.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>=3 and Duel.IsChainDisablable(0) and Duel.SelectYesNo(1-tp,aux.Stringid(24049,0)) then
		local g=Duel.SelectMatchingCard(1-tp,aux.TRUE,tp,0,LOCATION_HAND,3,3,nil)
		Duel.SendtoGrave(g,REASON_EFFECT)
	else
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCountLimit(1)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetLabel(0)
		e1:SetCondition(c24059.damcon)
		e1:SetOperation(c24059.damop)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN,3)
		Duel.RegisterEffect(e1,tp)
		local ct1=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local ct2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
		if ct1+ct2>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,24064,0,0x208,600,400,1,RACE_INSECT,ATTRIBUTE_DARK) then
		while ct1>0 do
			local token=Duel.CreateToken(tp,24064)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			ct1=ct1-1
		end
		while ct2>0 do
			local token=Duel.CreateToken(tp,24064)
			Duel.SpecialSummonStep(token,0,1-tp,1-tp,false,false,POS_FACEUP)
			ct2=ct2-1
		end
	end
	Duel.SpecialSummonComplete()
	end
end
function c24059.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c24059.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if(ct<3) then
		ct=ct+1
		e:SetLabel(ct)
		c:SetTurnCounter(ct)
		Duel.Damage(1-tp,600,REASON_EFFECT)
	end
end
