 
--春之倒影
function c20057.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c20057.target)
	e1:SetOperation(c20057.activate)
	c:RegisterEffect(e1)
end
function c20057.filter1(c)
	return (c:IsCode(20013) or c:IsCode(20016) or c:IsSetCard(0x123)) and c:IsFaceup()
end
function c20057.filter2(c,e,tp)
	return c:IsCode(20016) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c20057.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c20057.filter1(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c20057.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c20057.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c20057.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c20057.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c20057.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c20057.efilter)
		e1:SetOwnerPlayer(tp)
		sc:RegisterEffect(e1)
		sc:CompleteProcedure()
	end
	local c=e:GetHandler()
	c:CancelToGrave()
		Duel.Overlay(sc,Group.FromCards(c))
end
function c20057.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
