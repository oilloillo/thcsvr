--水符『河童河口大浪潮』
function c23052.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,23052)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c23052.target)
	e1:SetOperation(c23052.activate)
	c:RegisterEffect(e1)
end
function c23052.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<2 then return false end
		local g=Duel.GetDecktopGroup(tp,2)
		local result=g:FilterCount(Card.IsAbleToHand,nil)>0
		return result
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,0,LOCATION_DECK)
end
function c23052.filter(c)
	return (c:IsSetCard(0x817) or c:IsSetCard(0x820)) and c:IsAbleToHand()
end
function c23052.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,2)
	local g=Duel.GetDecktopGroup(p,2)
	if g:GetCount()>0 then
		local sg=g:Filter(c23052.filter,nil)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-p,sg)
			Duel.ShuffleHand(p)
			if sg:GetCount()<2 then
				g:RemoveCard(sg:GetFirst())
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
		else
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
		Duel.ShuffleDeck(p)
	end
end
