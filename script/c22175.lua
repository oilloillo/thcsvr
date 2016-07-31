 
--七曜-金土符「元素收割者」
function c22175.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c22175.con)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22175,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(c22175.acttg)
	e2:SetOperation(c22175.actop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_DECK)
	e3:SetCondition(c22175.actcon)
	c:RegisterEffect(e3)
	--atsdad
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22175,1))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c22175.cost)
	e4:SetTarget(c22175.target)
	e4:SetOperation(c22175.operation)
	c:RegisterEffect(e4)
end
function c22175.con(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():GetFlagEffect(22175)==1
end
function c22175.actfilter1(c)
	return c:IsSetCard(0x181) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsFaceup()
end
function c22175.actfilter2(c)
	return c:IsSetCard(0x180) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsFaceup()
end
function c22175.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22175.actfilter1,tp,LOCATION_SZONE,0,1,nil) and 
		Duel.IsExistingMatchingCard(c22175.actfilter2,tp,LOCATION_SZONE,0,1,nil) end
	e:GetHandler():RegisterFlagEffect(22175,RESET_EVENT+0x1fe0000,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c22175.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c22175.actfilter1,tp,LOCATION_SZONE,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c22175.actfilter2,tp,LOCATION_SZONE,0,1,1,nil)
	g1:Merge(g2)
		if Duel.SendtoGrave(g1,REASON_MATERIAL)~=0 then
			if not e:GetHandler():GetActivateEffect():IsActivatable(tp) then return end
			Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	Duel.RaiseEvent(e:GetHandler(),EVENT_CHAIN_SOLVED,e:GetHandler():GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
end
function c22175.dactfilter(c)
	return c:IsFaceup() and c:IsCode(22017)
end
function c22175.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22175.dactfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22175.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and Duel.GetFlagEffect(tp,888175)==0 end
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,888175,RESET_PHASE+PHASE_END,0,1)
end
function c22175.filter(c)
	return c:IsSetCard(0x177) and c:IsType(TYPE_SPELL) and c:IsAbleToDeck()
end
function c22175.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c22175.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.IsExistingTarget(c22175.filter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local noah=0
	if g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_EARTH)>0  then noah = noah + 1 end
	if g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WATER)>0  then noah = noah + 1 end
	if g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_FIRE)>0   then noah = noah + 1 end
	if g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WIND)>0   then noah = noah + 1 end
	if g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_LIGHT)>0  then noah = noah + 1 end
	if g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_DARK)>0   then noah = noah + 1 end
	if g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_DEVINE)>0 then noah = noah + 1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectTarget(tp,c22175.filter,tp,LOCATION_GRAVE,0,1,noah,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
end
function c22175.operation(e,tp,eg,ep,ev,re,r,rp)
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
