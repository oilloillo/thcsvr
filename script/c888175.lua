 
--七曜-金土符「元素收割者」
function c888175.initial_effect(c)
	--atsdad
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(888175,1))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCost(c888175.cost)
	e4:SetTarget(c888175.target)
	e4:SetOperation(c888175.operation)
	c:RegisterEffect(e4)
end
function c888175.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,888175)==0 end
	Duel.RegisterFlagEffect(tp,888175,RESET_PHASE+PHASE_END,0,1)
end
function c888175.filter(c)
	return c:IsSetCard(0x177) and c:IsType(TYPE_SPELL) and c:IsAbleToDeck()
end
function c888175.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c888175.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.IsExistingTarget(c888175.filter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local noah=1
	if g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_EARTH)>0  then noah = noah + 1 end
	if g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WATER)>0  then noah = noah + 1 end
	if g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_FIRE)>0   then noah = noah + 1 end
	if g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WIND)>0   then noah = noah + 1 end
	if g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_LIGHT)>0  then noah = noah + 1 end
	if g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_DARK)>0   then noah = noah + 1 end
	if g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_DEVINE)>0 then noah = noah + 1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectTarget(tp,c888175.filter,tp,LOCATION_GRAVE,0,1,noah,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
end
function c888175.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	local ag=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if ag:GetCount()>0 then
		local sc=ag:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(ct*100)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENCE)
			sc:RegisterEffect(e2)
			sc=ag:GetNext()
		end
	end
end
