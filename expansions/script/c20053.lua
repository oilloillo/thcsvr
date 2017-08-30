 
--现世的入口
function c20053.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c20053.condition)
	e1:SetTarget(c20053.target)
	e1:SetOperation(c20053.operation)
	c:RegisterEffect(e1)
end
function c20053.cfilter(c)
	return c:IsFaceup() and (c:IsCode(10000) or (c:IsSetCard(0xa225) and c:IsType(TYPE_MONSTER)) or (c:IsSetCard(0x208) and c:IsType(TYPE_SPIRIT)))
end
function c20053.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c20053.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c20053.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c20053.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,tc:GetPosition(),REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetOperation(c20053.retop)
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
	end
end
function c20053.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
