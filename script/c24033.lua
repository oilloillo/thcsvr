 
--「死灰复燃」
function c24033.initial_effect(c)
    --search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c24033.tg)
	e1:SetOperation(c24033.op)
	c:RegisterEffect(e1)
end
function c24033.filter(c)
	return c:IsSetCard(0x625) and c:IsAbleToHand()
end
function c24033.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c24033.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c24033.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c24033.filter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
end
function c24033.cfilter(c)
	return not c:IsPublic() and c:IsType(TYPE_TRAP)
end
function c24033.op(e,tp,eg,ep,ev,re,r,rp)
	local dis=false
	if Duel.IsChainDisablable(0) then
		local g=Duel.GetMatchingGroup(c24033.cfilter,tp,0,LOCATION_HAND,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(24033,0)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.ConfirmCards(tp,sg)
			Duel.ShuffleHand(1-tp)
			dis=true
		end
	end
	local tc=Duel.GetFirstTarget()
	if not dis and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
