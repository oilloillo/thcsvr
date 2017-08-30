--活着的历史
function c7001104.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c7001104.condition)
	e1:SetTarget(c7001104.target)
	e1:SetOperation(c7001104.operation)
	c:RegisterEffect(e1)
end
function c7001104.spfilter(c)
	return c:IsCode(21006) or c:IsCode(999204) or c:IsCode(21059)
end
function c7001104.filter(c)
	return c:IsSetCard(0x137) and c:IsType(TYPE_SYNCHRO)
end
function c7001104.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<2 and Duel.IsExistingMatchingCard(c7001104.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c7001104.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c7001104.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c7001104.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c7001104.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c7001104.splimit)
		Duel.RegisterEffect(e1,tp)
	end
end
function c7001104.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetAttribute()~=ATTRIBUTE_FIRE
end