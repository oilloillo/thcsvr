 
--冥界
function c20088.initial_effect(c)
	--gay
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c20088.activate)
	c:RegisterEffect(e1)
	--get
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20088,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CHAIN_UNIQUE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c20088.setcon)
	e2:SetTarget(c20088.settg)
	e2:SetOperation(c20088.setop)
	c:RegisterEffect(e2)
	--gat
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(20088,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CHAIN_UNIQUE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c20088.getcon)
	e3:SetTarget(c20088.gettg)
	e3:SetOperation(c20088.getop)
	c:RegisterEffect(e3)
	--sh
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetTarget(c20088.addct)
	e4:SetOperation(c20088.addc)
	c:RegisterEffect(e4)
end
function c20088.filter(c)
	return c:IsAbleToHand() and c:IsCode(20086)
end
function c20088.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c20088.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(20088,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c20088.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(Card.IsType,nil,TYPE_SPIRIT)>0
end
function c20088.tgfilter(c)
	return c:IsSetCard(0x684) and c:IsAbleToHand()
end
function c20088.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c20088.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20088.tgfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c20088.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c20088.setop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c20088.getcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(Card.IsSetCard,nil,0x684)>0
end
function c20088.gettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c20088.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20088.tgfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c20088.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c20088.getop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c20088.xfilter(c)
	return c:IsFaceup()
end
function c20088.addct(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c20088.xfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20088.xfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.SelectTarget(tp,c20088.xfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
end
function c20088.addc(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x28b,1)
	end
end
