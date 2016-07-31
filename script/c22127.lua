 
--天罚「六芒星」
function c22127.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c22127.target)
	e1:SetOperation(c22127.operation)
	c:RegisterEffect(e1)
end
function c22127.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x813)
end
function c22127.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22127.filter(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c22127.filter,tp,LOCATION_MZONE,0,1,nil) and 
		Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c22127.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,g2:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g2,g2:GetCount(),0,0)
end
function c22127.operation(e,tp,eg,ep,ev,re,r,rp)
	local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g2:FilterCount(Card.IsDestructable,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(22127,0)) then
		Duel.Destroy(g2,REASON_EFFECT)
	else
		Duel.ChangePosition(g2,POS_FACEDOWN_DEFENCE)
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
