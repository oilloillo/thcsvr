--光符『绝对正义』
function c26139.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c26139.condition)
	e1:SetTarget(c26139.target)
	e1:SetOperation(c26139.activate)
	c:RegisterEffect(e1)
end
function c26139.cfilter(c)
	return c:IsSetCard(0x251) and c:IsFaceup() and c:GetOriginalAttribute()==ATTRIBUTE_LIGHT
end
function c26139.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c26139.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c26139.filter(c)
	return c:IsAbleToRemove() and
		((c:IsFaceup() and c:IsType(TYPE_TRAP)) or (c:IsType(TYPE_MONSTER) and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL))
end
function c26139.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c26139.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26139.filter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c26139.filter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c26139.activate(e)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
