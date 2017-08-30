 
--背叛的少女～犹大之吻
function c15038.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c15038.target)
	e1:SetOperation(c15038.operation)
	c:RegisterEffect(e1)
end
function c15038.filter(c)
	return c:IsSetCard(0x150)
end
function c15038.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c15038.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingTarget(c15038.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c15038.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c15038.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
		Duel.Draw(tp,2,REASON_EFFECT)
	end
	Duel.RegisterFlagEffect(tp,150000,RESET_PHASE+PHASE_END,0,1)
end
