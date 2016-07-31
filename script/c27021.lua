 
--神灵庙
function c27021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27021,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c27021.cost)
	e2:SetTarget(c27021.target)
	e2:SetOperation(c27021.operation)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e3:SetDescription(aux.Stringid(27021,1))
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c27021.cost)
	e3:SetTarget(c27021.tg2)
	e3:SetOperation(c27021.op2)
	c:RegisterEffect(e3)
end
function c27021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,400) end
	Duel.PayLPCost(tp,400)
end
function c27021.filter(c)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsSetCard(0x208) and c:IsAbleToHand()
end
function c27021.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c27021.filter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(27021)==0 and Duel.IsExistingTarget(c27021.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c27021.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	e:GetHandler():RegisterFlagEffect(27021,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c27021.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c27021.filter2(c,e,tp)
	return c:IsSetCard(0x912) and c:IsAbleToHand() and c:GetCode()~=27021
end
function c27021.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(27021)==0 and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0xe,0,1,nil)
		and Duel.IsExistingMatchingCard(c27021.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0xe)
	e:GetHandler():RegisterFlagEffect(27021,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c27021.op2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c27021.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0xe,0,1,1,nil)
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
