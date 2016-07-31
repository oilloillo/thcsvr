--疵痕『损坏的护符』
function c23083.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c23083.target)
	e1:SetOperation(c23083.activate)
	c:RegisterEffect(e1)
end
function c23083.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(Card.IsAbleToGrave,tp,0,LOCATION_DECK,nil)>0
		and Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_EXTRA+LOCATION_DECK,0,nil)<=5 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
end
function c23083.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_DECK,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoGrave(g,REASON_EFFECT)
	local dg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,0xe,nil)
	if dg:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(23083,0)) then
		sg=dg:Select(1-tp,1,1,nil)
		Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
		dg:RemoveCard(sg:GetFirst())
	end
	while dg:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(23083,1)) do
		sg=dg:Select(1-tp,1,1,nil)
		Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
		dg:RemoveCard(sg:GetFirst())
	end
end
