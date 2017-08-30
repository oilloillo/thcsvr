 
--河童「光束剑武装」
function c23047.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c23047.condition)
	e1:SetTarget(c23047.target)
	e1:SetOperation(c23047.operation)
	c:RegisterEffect(e1)
	--sh
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c23047.sgcon)
	e2:SetTarget(c23047.sgtg)
	e2:SetOperation(c23047.sgop)
	c:RegisterEffect(e2)
end
function c23047.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c23047.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x817)
end
function c23047.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c23047.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c23047.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c23047.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c23047.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) then return end
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		c:CancelToGrave()
		--Atk/def
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(1000)
		c:RegisterEffect(e1)
		--Level
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_EQUIP)
		e3:SetCode(EFFECT_UPDATE_LEVEL)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetValue(2)
		c:RegisterEffect(e3)
		--Equip limit
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_EQUIP_LIMIT)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetValue(c23047.eqlimit)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e4)
	end
end
function c23047.eqlimit(e,c)
	return c:IsSetCard(0x817)
end
function c23047.sgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c23047.sgfilter(c)
	return c:IsSetCard(0x820) and c:IsAbleToHand()
end
function c23047.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23047.sgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c23047.sgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c23047.sgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
