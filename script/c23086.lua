--创符『痛苦之流』
function c23086.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c23086.target)
	e1:SetOperation(c23086.activate)
	c:RegisterEffect(e1)
end
function c23086.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x113)
end
function c23086.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23086.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c23086.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	local lv=g:GetFirst():GetLevel()
	e:SetLabel(lv*2)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,0,0,tp,lv*2)
end
function c23086.filter(c,lv)
	if c:GetLevel()>0 then
		return c:GetLevel()<=lv
	else
		return c:GetRank()<=lv
	end
end
function c23086.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	Duel.DiscardDeck(tp,ct,REASON_EFFECT)
	local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local g=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	local tc=g:GetFirst()
	while tc do
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CANNOT_REMOVE)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e4:SetValue(1)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e4)
		tc=g:GetNext()
	end
	if g:GetCount()==0 or tg:GetCount()==0 then return end
	local lv=g:FilterCount(Card.IsSetCard,nil,0x113)+g:FilterCount(Card.IsSetCard,nil,0x382)*2
	if lv==0 then return end
	local sg=tg:FilterSelect(tp,c23086.filter,1,1,nil,lv)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
