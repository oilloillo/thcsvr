--邪符『孤魂野鬼』
function c27062.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c27062.target)
	e1:SetOperation(c27062.activate)
	c:RegisterEffect(e1)
end
function c27062.cfilter(c)
	return c:IsSetCard(0x240) and c:IsFaceup()
end
function c27062.filter(c,e,tp)
	return bit.band(c:GetReason(),REASON_RELEASE)~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c27062.spfilter(c,e,tp,code)
	return c:GetCode()==code and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c27062.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c27062.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c27062.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c27062.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c27062.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c27062.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_TRIGGER)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetValue(1)
		tc:RegisterEffect(e3,true)
		local code=tc:GetCode()
		local g=Duel.GetMatchingGroup(c27062.spfilter,tp,LOCATION_HAND,0,nil,e,tp,code)
		local gc=g:GetCount()
		if gc>0 and Duel.SelectYesNo(tp,aux.Stringid(27062,0)) then
			tc=g:GetFirst()
			while tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1,true)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e2,true)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_CANNOT_TRIGGER)
				e3:SetReset(RESET_EVENT+0x1fe0000)
				e3:SetValue(1)
				tc:RegisterEffect(e3,true)
				tc=g:GetNext()
				Duel.SpecialSummonComplete()
				local d=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,gc,gc,nil)
				Duel.Destroy(d,REASON_EFFECT)
			end
		end
	end
end

