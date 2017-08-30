--女神化 黃昏之心
function c70029.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2,c70029.ovfilter,aux.Stringid(70029,0))
	c:EnableReviveLimit()
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c70029.destg)
	e1:SetValue(c70029.value)
	c:RegisterEffect(e1)
	--atkdown
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(70029,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c70029.cost)
	e2:SetTarget(c70029.target)
	e2:SetOperation(c70029.operation)
	c:RegisterEffect(e2)
end
function c70029.ovfilter(c)
	return c:IsFaceup() and c:IsCode(70027) and bit.band(c:GetSummonType(),SUMMON_TYPE_NORMAL)==SUMMON_TYPE_NORMAL
end
function c70029.dfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x149) and not c:IsReason(REASON_REPLACE) and c:IsControler(tp)
end
function c70029.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not eg:IsContains(e:GetHandler())
		and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and eg:IsExists(c70029.dfilter,1,nil,tp) end
	if Duel.SelectYesNo(tp,aux.Stringid(70029,1)) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end
function c70029.value(e,c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x149) and not c:IsReason(REASON_REPLACE) and c:IsControler(e:GetHandlerPlayer())
end
function c70029.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c70029.filter(c)
	return c:IsFaceup() and c:GetAttack()>0 and c:IsDisabled() and c:IsType(TYPE_EFFECT)
end
function c70029.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c70029.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c70029.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c70029.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c70029.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:GetAttack()>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
