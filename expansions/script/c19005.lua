--简易光融合『赞美太阳』
function c19005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,19005+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c19005.cost)
	e1:SetTarget(c19005.target)
	e1:SetOperation(c19005.activate)
	c:RegisterEffect(e1)
end
function c19005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c19005.filter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x208) and not c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevelBelow(5) and not c:IsType(TYPE_TUNER)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial()
end
function c19005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c19005.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c19005.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c19005.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	tc:SetMaterial(nil)
	if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3,true)
		tc:RegisterFlagEffect(19005,RESET_EVENT+0x1fe0000,0,1)
		tc:CompleteProcedure()
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_PHASE+PHASE_END)
		e4:SetCountLimit(1)
		e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e4:SetLabelObject(tc)
		e4:SetCondition(c19005.descon)
		e4:SetOperation(c19005.desop)
		Duel.RegisterEffect(e4,tp)
	end
end
function c19005.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(19005)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c19005.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
