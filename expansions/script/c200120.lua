--天候-梅雨
function c200120.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--ret
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetDescription(aux.Stringid(200120,0))
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,200120)
	e1:SetTarget(c200120.target)
	e1:SetOperation(c200120.activate)
	c:RegisterEffect(e1)
end
function c200120.filter(c)
	local x=c:GetOriginalCode()
	return ((x>=200001 and x<=200020) or (x>=200201 and x<=200221) or (x==200302) or (x==25016)) and c:IsAbleToDeck()
end
function c200120.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c200120.filter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=4 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,4)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c200120.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsOnField() then return end
	local g=Duel.GetMatchingGroup(c200120.filter,tp,LOCATION_GRAVE,0,nil)
	if g:GetClassCount(Card.GetCode)>=4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g2=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g2:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g3=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g3:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g4=g:Select(tp,1,1,nil)
		g1:Merge(g2)
		g1:Merge(g3)
		g1:Merge(g4)
		Duel.ConfirmCards(1-tp,g1)
		if Duel.SendtoDeck(g1,nil,0,REASON_EFFECT)>0 then 
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT) 
		end
	end
end