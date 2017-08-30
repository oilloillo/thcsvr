 
--红魔馆·里
function c22117.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--lvup
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(22117,1))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_SZONE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetTarget(c22117.target)
	e6:SetOperation(c22117.operation)
	c:RegisterEffect(e6)
	--lvdown
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22117,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c22117.target1)
	e2:SetOperation(c22117.operation1)
	c:RegisterEffect(e2)
	--tuner
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22117,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c22117.target2)
	e3:SetOperation(c22117.operation2)
	c:RegisterEffect(e3)
	--decrease tribute
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DECREASE_TRIBUTE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_HAND,0)
	e4:SetCondition(c22117.condition)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x813))
	e4:SetValue(0x1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_DECREASE_TRIBUTE_SET)
	c:RegisterEffect(e5)
end
function c22117.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x208) and c:IsLevelAbove(1)
end
function c22117.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22117.filter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(22117)<=1 and Duel.IsExistingTarget(c22117.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c22117.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	e:GetHandler():RegisterFlagEffect(22117,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,221170,RESET_PHASE+PHASE_END,0,1)
end
function c22117.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		if tc:IsSetCard(0x813) or tc:IsSetCard(0x999) then
			return true
		else
			e:GetHandler():RegisterFlagEffect(22117,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function c22117.filter1(c)
	return c:IsFaceup() and c:IsLevelAbove(2)
end
function c22117.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22117.filter1(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(22117)<=1 and Duel.IsExistingTarget(c22117.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c22117.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	e:GetHandler():RegisterFlagEffect(22117,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,221170,RESET_PHASE+PHASE_END,0,1)
end
function c22117.operation1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(-1)
		tc:RegisterEffect(e1)
	end
end
function c22117.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x813) and not c:IsType(TYPE_TUNER)
end
function c22117.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22117.filter2(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(22117)<=1 and Duel.IsExistingTarget(c22117.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c22117.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	e:GetHandler():RegisterFlagEffect(22117,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,221170,RESET_PHASE+PHASE_END,0,1)
end
function c22117.operation2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
	end
end
function c22117.condition(e,tp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,221170)~=0
end
