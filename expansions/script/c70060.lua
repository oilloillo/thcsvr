--艾尔芙
function c70060.initial_effect(c)
	--confirm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(70060,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c70060.target)
	e1:SetOperation(c70060.operation)
	c:RegisterEffect(e1)
end
function c70060.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function c70060.filter(c)
	return (c:IsCode(70001) or c:IsCode(70030)) and c:IsAbleToHand()
end
function c70060.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFacedown() then
		if tc:GetControler()==1-tp then
			Duel.ConfirmCards(tp,tc)
		else
			Duel.ConfirmCards(1-tp,tc)
		end
	end
	local g=Duel.GetMatchingGroup(c70060.filter,tp,LOCATION_DECK,0,nil)
	if tc:IsType(TYPE_TRAP) and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(70060,1)) then
		sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
