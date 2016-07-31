 
--ç³É«ÃüÔË
function c22105.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c22105.target)
	e1:SetOperation(c22105.activate)
	c:RegisterEffect(e1)
end
function c22105.filter(c)
	return (c:IsSetCard(0x813) or c:GetOriginalCode()==(22100) or c:GetOriginalCode()==(22117)) and c:IsAbleToHand()
end
function c22105.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22105.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,1)
end
function c22105.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22105.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.BreakEffect()
	Duel.DiscardDeck(1-tp,1,REASON_EFFECT)
end