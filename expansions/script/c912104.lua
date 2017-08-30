--金发联萌
function c912104.initial_effect(c)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c912104.cost)
	e1:SetTarget(c912104.target)
	e1:SetOperation(c912104.activate)
	c:RegisterEffect(e1)
end
function c912104.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c912104.filter(c)
	return c:IsSetCard(0x403)  and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c912104.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1)
		and Duel.IsExistingMatchingCard(c912104.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c912104.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c912104.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local dc=Duel.GetOperatedGroup():GetFirst()
    	if  (dc:IsCode(4031101) or dc:IsCode(4031103))
		and Duel.SelectYesNo(tp,aux.Stringid(912104,0)) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 then
		Duel.ConfirmDecktop(tp,3)
	    local g=Duel.GetDecktopGroup(tp,3)
	    if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		if g:IsExists(c912104.filter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(912104,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c912104.filter,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			g:Sub(sg)
		end
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
	end
end
end
end