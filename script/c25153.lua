--幻想『花鸟风月，啸风弄月』
function c25153.initial_effect(c)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c25153.target)
	e1:SetOperation(c25153.operation)
	c:RegisterEffect(e1)
	--cannot disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE)
	e2:SetCondition(c25153.con)
	c:RegisterEffect(e2)
end
function c25153.con(e)
	local ct4=Duel.GetMatchingGroupCount(Card.IsCode,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,25154)
	return ct4>=0
end
function c25153.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3208)
end
function c25153.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c25153.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c25153.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c25153.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local ct1=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,25150)
	local ct2=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,25151)
	local ct3=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,25152)
	local ct4=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,25154)
	if ct1>0 then
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct1*1500)
	end
	if ct2>0 then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
	end
	if ct3>0 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct3)
	end
	if ct4==3 then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c25153.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENCE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(1500)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(1500)
		tc:RegisterEffect(e2)
		local ct1=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,25150)
		local ct2=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,25151)
		local ct3=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,25152)
		local ct4=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,25154)
		Duel.Recover(tp,ct1*1500,REASON_EFFECT)
		if ct2>0 then
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,ct2*2,nil)
			Duel.HintSelection(g)
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
			if g:IsExists(Card.IsControler,1,nil,tp) then
				Duel.ShuffleDeck(tp)
			end
			if g:IsExists(Card.IsControler,1,nil,1-tp) then
				Duel.ShuffleDeck(1-tp)
			end
		end
		Duel.Draw(tp,ct3,REASON_EFFECT)
		if ct4>1 then
			local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
			local sg=g:GetFirst()
			while sg do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				sg:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				sg:RegisterEffect(e2)
				sg=g:GetNext()
			end
		end
	end
end
