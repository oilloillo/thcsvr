 
--晓型驱逐舰-晓
function c50187.initial_effect(c)
	local temp = 0
	while temp<6 do
		c:RegisterFlagEffect(50200,0,0,0)
		temp = temp+1
	end
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50187,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c50187.sptg)
	e2:SetOperation(c50187.spop)
	c:RegisterEffect(e2)
	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.FALSE)
	c:RegisterEffect(e3)
end
function c50187.filter(c,e,tp)
	return c:IsSetCard(0x514) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50187.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c50187.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c50187.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c50187.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e3:SetValue(c50187.synlimit)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3,true)
		Duel.SpecialSummonComplete()
	end
end
function c50187.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x4bb)
end
