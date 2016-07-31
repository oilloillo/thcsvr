 
--七曜-金土符「淡黄色的阵风」
function c888176.initial_effect(c)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(888176,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetTarget(c888176.target)
	e4:SetOperation(c888176.operation)
	c:RegisterEffect(e4)
end
function c888176.filter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c888176.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(c888176.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c888176.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetChainLimit(c888176.climit)
end
function c888176.climit(e,tp)
	return e:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c888176.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
