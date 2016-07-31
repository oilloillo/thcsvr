 
--符器-左扇
function c200209.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c200209.target)
	e1:SetOperation(c200209.activate)
	c:RegisterEffect(e1)
end
function c200209.filter(c)
	return c:IsPosition(POS_DEFENCE) and c:IsDestructable()
end
function c200209.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c200209.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c200209.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c200209.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c200209.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsPosition(POS_DEFENCE) and tc:IsDestructable() and tc:IsRelateToEffect(e) then
		if tc:IsPosition(POS_FACEDOWN_DEFENCE) and tc:IsAbleToRemove() then Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
		else 
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end