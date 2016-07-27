--丰收与成熟的象征
function c999303.initial_effect(c)
	--syn summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_PLANT),1)
	c:EnableReviveLimit()
	-- sp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999303,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetLabel(0)
	e1:SetTarget(c999303.sptg)
	e1:SetOperation(c999303.spop)
	c:RegisterEffect(e1)
	--Cost Change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_LPCOST_CHANGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,0)
	e3:SetValue(c999303.costchange)
	c:RegisterEffect(e3)
	--mat check
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c999303.valcheck)
	c:RegisterEffect(e4)
	e4:SetLabelObject(e1)
	--synchro success
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c999303.regcon)
	e5:SetOperation(c999303.regop)
	c:RegisterEffect(e5)
	e5:SetLabelObject(e4)
end
c999303.DescSetName=0xa2
function c999303.filter(c)
	return c:IsRace(RACE_PLANT)
end

function c999303.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local count = e:GetLabel()
	if chk==0 then return count>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=count
		and Duel.IsPlayerCanSpecialSummonMonster(tp,999300,0,0x4011,0,0,2,RACE_PLANT,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,count,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,count,0,0)
end

function c999303.spop(e,tp,eg,ep,ev,re,r,rp)
	local count = e:GetLabel()
	if count>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=count
		and Duel.IsPlayerCanSpecialSummonMonster(tp,999300,0,0x4011,0,0,2,RACE_PLANT,ATTRIBUTE_EARTH) then
		for i=1,count do
			local token=Duel.CreateToken(tp,999300)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
end

function c999303.costchange(e,re,rp,val)
	if re then
		local c=re:GetHandler()
		if not c then return val end

		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]

		if code ~= 999311 and mt and mt.DescSetName == 0xa2 then return 0 end
	end
	
	return val
end

function c999303.valcheck(e,c)
	local g=c:GetMaterial()
	e:SetLabel(0)
	local count = 0
	local tc=g:GetFirst()
	while tc do
		if tc:GetOriginalCode()==999301 then
			e:SetLabel(e:GetLabel()+1)
		elseif tc:GetOriginalCode()==999302 then
			e:SetLabel(e:GetLabel()+2)
		end

		if tc:IsRace(RACE_PLANT) and not tc:IsType(TYPE_TUNER) then count = count + 1 end
		tc=g:GetNext()
	end
	e:GetLabelObject():SetLabel(count)
end

function c999303.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
		and e:GetLabelObject():GetLabel()~=0
end

function c999303.regop(e,tp,eg,ep,ev,re,r,rp)
	local att=e:GetLabelObject():GetLabel()
	local c=e:GetHandler()
	if bit.band(att,1)~=0 then
		c:CopyEffect(999301, RESET_EVENT+0x1fe0000, 1)
	end
	if bit.band(att,2)~=0 then
		c:CopyEffect(999302, RESET_EVENT+0x1fe0000, 1)
	end
	e:SetLabel(0)
end