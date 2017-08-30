--沉没的深海栖舰
function c401206.initial_effect(c)
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(401206,0))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetTarget(c401206.target1)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetOperation(c401206.operation1)
	c:RegisterEffect(e4)
	end
function c401206.filter(c)
	return c:IsFacedown() and c:IsSetCard(0x911)
end
function c401206.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and ce2.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c401206.filter,tp,LOCATION_REMOVED,0,1,nil) 
	and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) end 
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(401206,3))
	local g=Duel.SelectTarget(tp,c401206.filter,tp,LOCATION_REMOVED,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c401206.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 and  Duel.SendtoDeck(g,nil,1,REASON_EFFECT)~=0 then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
	end
end