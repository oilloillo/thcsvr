 
--开海「海水分开之日」
function c23037.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c23037.cost)
	e1:SetTarget(c23037.target)
	e1:SetOperation(c23037.activate)
	c:RegisterEffect(e1)
end
function c23037.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c23037.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23037.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c23037.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function c23037.filter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c23037.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c23037.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c23037.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c23037.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c23037.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
