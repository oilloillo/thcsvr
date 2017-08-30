 
--地上的白兔
function c21027.initial_effect(c)
	--tuner
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21027,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c21027.target)
	e1:SetOperation(c21027.operation)
	c:RegisterEffect(e1)
end
function c21027.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x256) and not c:IsType(TYPE_TUNER)
end
function c21027.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c21027.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21027.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c21027.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c21027.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
	end
end
