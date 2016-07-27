--『小恶灵复活』
function c24116.initial_effect(c)
    --search
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c24116.tg)
	e1:SetOperation(c24116.op)
	c:RegisterEffect(e1)
end
function c24116.filter(c,e,tp)
	return c:IsSetCard(0x625) and c:GetLevel()==1 and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c24116.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c24116.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c24116.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c24116.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetHandler(),e,tp)
end
function c24116.cfilter(c)
	return not c:IsPublic() and c:IsType(TYPE_TRAP)
end
function c24116.op(e,tp,eg,ep,ev,re,r,rp)
	local dis=false
	if Duel.IsChainDisablable(0) then
		local g=Duel.GetMatchingGroup(c24116.cfilter,tp,0,LOCATION_HAND,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(24033,0)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.ConfirmCards(tp,sg)
			Duel.ShuffleHand(1-tp)
			dis=true
		end
	end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or dis then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(24116,1))) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	elseif tc:IsAbleToHand() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
