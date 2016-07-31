--大声『激动的呼喊』
function c27145.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c27145.sptg)
	e1:SetOperation(c27145.spop)
	c:RegisterEffect(e1)
end
function c27145.spfilter(c,e,tp)
	return c:GetOriginalLevel()==2 and c:IsSetCard(0x208) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsLocation(LOCATION_SZONE) and (c:GetSequence()==6 or c:GetSequence()==7) or not c:IsLocation(LOCATION_SZONE))
end
function c27145.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x527)
end
function c27145.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c27145.spfilter,tp,0x1a,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x1a)
	if Duel.GetMatchingGroupCount(c27145.cfilter,tp,LOCATION_MZONE,0,nil)>0 then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c27145.filter(c,def)
	return c:IsFaceup() and c:IsAbleToHand() and c:GetDefence()<=def
end
function c27145.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c27145.spfilter,tp,0x1a,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		local def=tc:GetDefence()
		local sg=Duel.GetMatchingGroup(c27145.filter,tp,0,LOCATION_MZONE,nil,def)
		if e:GetLabel()>0 and sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		end
	end
end
