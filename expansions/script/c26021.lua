 
--星莲-未知飞行少女 封兽鵺
function c26021.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x208),6,2)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26021,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c26021.con)
	e1:SetTarget(c26021.tg)
	e1:SetOperation(c26021.op)
	c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26021,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,26020)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c26021.cost)
	e2:SetTarget(c26021.target)
	e2:SetOperation(c26021.operation)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetCondition(c26021.econdition)
	e3:SetTarget(c26021.etarget)
	e3:SetValue(c26021.efilter)
	c:RegisterEffect(e3)
end
function c26021.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c26021.filter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x208) and c:IsLevelBelow(5) and c:IsFaceup()
end
function c26021.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c26021.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26021.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c26021.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c26021.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c26021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c26021.cfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c26021.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c26021.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26021.cfilter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c26021.cfilter,tp,0,LOCATION_GRAVE,1,1,nil)
end
function c26021.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local code=tc:GetOriginalCode()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		c:CopyEffect(code, RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END, 1)
	end
end
function c26021.econdition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOverlayCount()~=0
end
function c26021.etarget(e,c)
	return c:IsFaceup() and (c:IsSetCard(0x251) or c:IsSetCard(0x252))
end
function c26021.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer()
end
