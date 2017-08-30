 
--黄泉国的通信
function c21049.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCost(c21049.cost)
	e1:SetTarget(c21049.target)
	e1:SetOperation(c21049.activate)
	c:RegisterEffect(e1)
end
function c21049.cffilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c21049.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21049.cffilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c21049.cffilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c21049.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsSetCard(0x132)
end
function c21049.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c21049.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21049.tgfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c21049.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c21049.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
