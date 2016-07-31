 
--人鬼「未来永劫斩」
function c20069.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c20069.condition)
	e1:SetTarget(c20069.target)
	e1:SetOperation(c20069.operation)
	c:RegisterEffect(e1)
end
function c20069.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x713)
end
function c20069.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>1 and Duel.CheckChainUniqueness() and Duel.IsExistingMatchingCard(c20069.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c20069.filter(c)
	return c:IsAbleToRemove()
end
function c20069.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c20069.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20069.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c20069.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,g:GetFirst():GetTextAttack())
end
function c20069.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
		local atk=tc:GetAttack()
		if atk<0 then atk=0 end
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		end
	end
end
