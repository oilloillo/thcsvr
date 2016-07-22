--月有丛云 花有风
function c25154.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c25154.operation)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(25154,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c25154.spcon)
	e2:SetTarget(c25154.sptg)
	e2:SetOperation(c25154.spop)
	c:RegisterEffect(e2)
end
function c25154.smfilter(c)
	return c:IsSetCard(0x3208)
end
function c25154.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,21126)==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
		e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
		e1:SetTarget(aux.TargetBoolFunction(c25154.smfilter))
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,21126,RESET_PHASE+PHASE_END,0,1)
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c25154.sucop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_END)
	e3:SetOperation(c25154.cedop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetLabelObject(e2)
	Duel.RegisterEffect(e3,tp)
end
function c25154.chainlm(e,rp,tp)
	return tp==rp
end
function c25154.sucfilter(c)
	return c:IsSetCard(0x208)
end
function c25154.sucop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c25154.sucfilter,1,nil) then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c25154.cedop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckEvent(EVENT_SUMMON_SUCCESS) and e:GetLabelObject():GetLabel()==1 then
		Duel.SetChainLimitTillChainEnd(c25154.chainlm)
	end
end
function c25154.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_PLANT)
end
function c25154.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c25154.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and not e:GetHandler():IsReason(REASON_RETURN)
end
function c25154.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,25162,0x208,0x4011,0,800,1,RACE_PLANT,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c25154.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,25162,0x208,0x4011,0,800,1,RACE_PLANT,ATTRIBUTE_WIND) then
		for i = 1,2 do
			local token=Duel.CreateToken(tp,25162)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
end
