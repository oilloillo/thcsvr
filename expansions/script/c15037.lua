 
--绯红的少女～绯红之死!!
function c15037.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c15037.condition)
	e1:SetTarget(c15037.target)
	e1:SetOperation(c15037.activate)
	c:RegisterEffect(e1)
end
function c15037.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x150)
end
function c15037.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c15037.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c15037.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c15037.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
	Duel.RegisterFlagEffect(tp,15000,RESET_PHASE+PHASE_END,0,1)
end
