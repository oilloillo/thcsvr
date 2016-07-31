 
--灵战～毁灭危机
function c14029.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c14029.target)
	e1:SetOperation(c14029.activate)
	c:RegisterEffect(e1)
end
function c14029.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c14029.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c14029.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(c14029.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c14029.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,4,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	local gc=g:GetCount()
	e:SetLabel(gc)
end
function c14029.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
	local gc=e:GetLabel()
	local g=Duel.GetOperatedGroup()
	local ct1=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
	local ct2=g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
	if ct1+ct2==gc then
		if ct1~=0 and g:IsExists(Card.IsControler,1,nil,tp) then
			Duel.ShuffleDeck(tp)
		end
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
