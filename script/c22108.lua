 
--冥符「红色的冥界」
function c22108.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c22108.target)
	e1:SetOperation(c22108.activate)
	c:RegisterEffect(e1)
end
function c22108.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and c:IsSetCard(0x813)
end
function c22108.tdfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c22108.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22108.tgfilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
end
function c22108.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22108.tgfilter,tp,LOCATION_DECK,0,2,2,nil)
	if g:GetCount()>0 and
		Duel.SendtoGrave(g,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(22108,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tc=Duel.SelectMatchingCard(tp,c22108.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.HintSelection(tc)
		Duel.SendtoDeck(tc,tp,2,REASON_EFFECT)
	end
end
