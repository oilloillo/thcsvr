 
--Uni
function c70036.initial_effect(c)
	--to deck and draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(70036,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c70036.tg)
	e1:SetOperation(c70036.op)
	c:RegisterEffect(e1)
end
function c70036.filter(c)
	return c:IsSetCard(0x149) and c:IsAbleToDeck()
end
function c70036.cfilter(c)
	return c:IsSetCard(0x149) and c:IsFaceup()
end
function c70036.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c70036.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c70036.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) and Duel.IsExistingTarget(c70036.filter,tp,LOCATION_GRAVE,0,3,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,c70036.filter,tp,LOCATION_GRAVE,0,3,3,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	e:GetHandler():RegisterFlagEffect(e:GetHandler(),70036,RESET_EVENT+0x1fe0000,0,0)
end
function c70036.op(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==3 then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
