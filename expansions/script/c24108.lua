--本能『本我的解放』
function c24108.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,24108)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c24108.target)
	e1:SetOperation(c24108.activate)
	c:RegisterEffect(e1)
end
function c24108.sfilter(c)
	return c:IsCode(24038) and c:IsSSetable(true)
end
function c24108.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<6 then return false end
		local g=Duel.GetDecktopGroup(tp,6)
		local result=g:FilterCount(Card.IsAbleToHand,nil)>0
		return result and Duel.IsExistingMatchingCard(c24108.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,0,LOCATION_DECK)
end
function c24108.filter(c)
	return c:IsSetCard(0x625) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c24108.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,6)
	local g=Duel.GetDecktopGroup(p,6)
	if g:GetCount()>0 then
		local sg=g:Filter(c24108.filter,nil)
		if sg:GetCount()>0 then
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
		Duel.ShuffleDeck(p)
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c24108.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g:GetFirst())
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
