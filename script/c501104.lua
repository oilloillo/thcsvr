--无限之魔女-瓦尔基莉亚
function c501104.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2,c501104.ovfilter,aux.Stringid(501104,0))
	c:EnableReviveLimit()
	--recover conversion
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_REVERSE_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(501104,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c501104.cost)
	e2:SetTarget(c501104.target)
	e2:SetOperation(c501104.operation)
	c:RegisterEffect(e2)
end
function c501104.ovfilter2(c)
	return c:IsSetCard(0x811) and c:IsFaceup() 
end
function c501104.ovfilter(c)
	return c:IsFaceup() and  c:IsRankBelow(7) and c:IsSetCard(0x811) and Duel.IsExistingMatchingCard(c501104.ovfilter2,c:GetControler(),LOCATION_GRAVE,0,7,nil)
end
function c501104.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c501104.filter(c)
	return c:IsSetCard(0x811) and c:IsAbleToDeck()
end
function c501104.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c501104.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c501104.filter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c501104.filter,tp,LOCATION_GRAVE,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c501104.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
	local dg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if ct>0 and dg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local rg=dg:Select(tp,1,ct,nil)
		Duel.HintSelection(rg)
		Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
	end
end