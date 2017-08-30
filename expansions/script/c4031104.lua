--黄金拼图-小路绫
function c4031104.initial_effect(c)
    --
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(4031104,0))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_HAND)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,4031104)
	e4:SetCost(c4031104.discost)
	e4:SetTarget(c4031104.target)
	e4:SetOperation(c4031104.activate)
	c:RegisterEffect(e4)
    --tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4031104,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,4031104)
	e2:SetCondition(c4031104.condition2)
	e2:SetTarget(c4031104.thtg)
	e2:SetOperation(c4031104.thop)
	c:RegisterEffect(e2)
end
function c4031104.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c4031104.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
end
function c4031104.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		tc:RegisterFlagEffect(4031104,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetCondition(c4031104.discon)
		e1:SetOperation(c4031104.disop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
end
end
function c4031104.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(4031104)==0 or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(tc) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c4031104.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c4031104.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
function c4031104.filter(c)
	return c:IsSetCard(0x403) and c:IsType(TYPE_MONSTER) and not c:IsCode(4031104) and c:IsAbleToHand()
end
function c4031104.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c4031104.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c4031104.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c4031104.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c4031104.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end