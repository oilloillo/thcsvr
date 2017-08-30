--遗愿成就之臂
function c210019.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c210019.cost)
	e1:SetTarget(c210019.target)
	e1:SetOperation(c210019.activate)
	c:RegisterEffect(e1)
end
function c210019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c210019.filter(c)
	return c:IsFaceup() and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and not c:IsType(TYPE_PENDULUM)
end
function c210019.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsLocation(LOCATION_ONFIELD) or chkc:IsLocation(LOCATION_GRAVE)) and c210019.filter(chkc) end
	local m=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return (m>1 or (e:GetHandler():IsLocation(LOCATION_ONFIELD) and m>0))
	and Duel.IsExistingTarget(c210019.filter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,c210019.filter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
end
function c210019.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end
