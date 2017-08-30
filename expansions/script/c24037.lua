 
--复燃「恋的埋火」
function c24037.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c24037.target)
	e1:SetOperation(c24037.activate)
	c:RegisterEffect(e1)
end
function c24037.filter(c)
	return c:IsSetCard(0x625) and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function c24037.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c24037.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c24037.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c24037.filter,tp,LOCATION_GRAVE,0,1,4,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c24037.cfilter(c)
	return not c:IsPublic() and c:IsType(TYPE_SPELL)
end
function c24037.tgfilter(c,e)
	return not c:IsRelateToEffect(e)
end
function c24037.activate(e,tp,eg,ep,ev,re,r,rp)
	local dis=false
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.IsChainDisablable(0) then
		local g=Duel.GetMatchingGroup(c24037.cfilter,tp,0,LOCATION_HAND,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(24037,0)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.ConfirmCards(tp,sg)
			Duel.ShuffleHand(1-tp)
			dis=true
		end
	end
	if not dis then 
	    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	        if tg:IsExists(c24037.tgfilter,1,nil,e) then return end
		    local tf=Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
		    Duel.ShuffleDeck(tp)
		    Duel.BreakEffect()
		    Duel.Draw(tp,1,REASON_EFFECT)
		    if tf>=3 then
		    	Duel.Draw(tp,1,REASON_EFFECT)
		    end
        end
end
