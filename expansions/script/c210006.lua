--茨华仙宠✿番虎
function c210006.initial_effect(c)
	--nontuner
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e1)
	--synchro level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SYNCHRO_LEVEL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c210006.slevel)
	c:RegisterEffect(e2)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(210006,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c210006.target)
	e1:SetOperation(c210006.operation)
	c:RegisterEffect(e1)
	--ltg
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(210006,3))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c210006.lcon)
	e4:SetTarget(c210006.ltg)
	e4:SetOperation(c210006.lop)
	c:RegisterEffect(e4)
end
function c210006.slevel(e,c)
	local lv=e:GetHandler():GetLevel()
	return (lv+1)*65536+lv
end
function c210006.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x710) and c:IsLevelAbove(1)
end
function c210006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c210006.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c210006.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c210006.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local op=0
	if tc:GetLevel()==1 then op=Duel.SelectOption(tp,aux.Stringid(210006,1))
	else op=Duel.SelectOption(tp,aux.Stringid(210006,1),aux.Stringid(210006,2)) end
	e:SetLabel(op)
end
function c210006.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		if e:GetLabel()==0 then
			e1:SetValue(1)
		else e1:SetValue(-1) end
		tc:RegisterEffect(e1)
	end
end
function c210006.lcon(e,tp,eg,ep,ev,re,r,rp)
	return (bit.band(r,REASON_EFFECT)~=0 or bit.band(r,REASON_SYNCHRO)~=0)-- and rp==tp
end
function c210006.ltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup()  end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c210006.lop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetDescription(aux.Stringid(210006,4))
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_NO_TURN_RESET)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e3:SetCountLimit(1)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e3)
	end
end