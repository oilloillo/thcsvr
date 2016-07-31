 
--百器徒然袋
function c21470020.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,21470020+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c21470020.target)
	e1:SetOperation(c21470020.activate)
	c:RegisterEffect(e1)	
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21470020,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c21470020.cost)
	e2:SetTarget(c21470020.thtg)
	e2:SetOperation(c21470020.thop)
	c:RegisterEffect(e2)
end
function c21470020.filter(c)
	return c:IsSetCard(0x742) and c:IsAbleToDeck() and c:IsAbleToHand()
end
function c21470020.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c21470020.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21470020.filter,tp,LOCATION_GRAVE,0,5,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c21470020.filter,tp,LOCATION_GRAVE,0,5,5,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,0,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c21470020.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not sg or sg:FilterCount(Card.IsRelateToEffect,nil,e)~=5 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=sg:Select(tp,1,1,nil):GetFirst()
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	local tg=sg:Filter(aux.TRUE,tc)
	if Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)>0 then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c21470020.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c21470020.tdfilter(c)
	return c:IsSetCard(0x742) and c:IsAbleToDeck()
end
function c21470020.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:GetControler()==tp and c21470020.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21470020.tdfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c21470020.tdfilter,tp,LOCATION_REMOVED,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c21470020.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
end