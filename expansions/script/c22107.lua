 
--二人之从者
function c22107.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCondition(c22107.condition)
	e1:SetTarget(c22107.target)
	e1:SetOperation(c22107.operation)
	c:RegisterEffect(e1)
end
function c22107.cfilter(c,code)
	return c:IsFaceup() and c:IsSetCard(code)
end
function c22107.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22107.cfilter,tp,LOCATION_MZONE,0,1,nil,0x713)
		 and Duel.IsExistingMatchingCard(c22107.cfilter,tp,LOCATION_MZONE,0,1,nil,0x816)
end
function c22107.filter(c)
	return c:IsDestructable()
end
function c22107.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c22107.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(c22107.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c22107.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22107.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Destroy(sg,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
