 
--演出的准备
function c20054.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c20054.cost)
	e1:SetTarget(c20054.target)
	e1:SetOperation(c20054.operation)
	c:RegisterEffect(e1)
end
function c20054.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,400)
	else Duel.PayLPCost(tp,400)	end
end
function c20054.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x208) and c:IsDestructable()
end
function c20054.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c20054.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c20054.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c20054.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c20054.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local ct=Duel.Draw(tp,1,REASON_EFFECT)
	end
end