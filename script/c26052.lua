 
--命莲-光符「正义的威光」
function c26052.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26052.target)
	e1:SetOperation(c26052.activate)
	c:RegisterEffect(e1)
end
function c26052.tgfilter(c)
	return (c:IsSetCard(0x208) or c:IsSetCard(0x252)) and c:IsAbleToGrave()
end
function c26052.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c26052.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c26052.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingTarget(c26052.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c26052.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local op=0
	if tc:GetLevel()==1 then op=Duel.SelectOption(tp,aux.Stringid(26052,0))
	else op=Duel.SelectOption(tp,aux.Stringid(26052,0),aux.Stringid(26052,1)) end
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c26052.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26052.tgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		if e:GetLabel()==0 then
			e1:SetValue(1)
		else e1:SetValue(-1) end
		tc:RegisterEffect(e1)
	end
end
function c26052.filter(c)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsSetCard(0x251)
end
