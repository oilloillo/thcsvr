 
--红魔 图书馆的恶魔
function c22046.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(c22046.synfilter),1)
	c:EnableReviveLimit()
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22046,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c22046.condition)
	e2:SetTarget(c22046.target)
	e2:SetOperation(c22046.operation)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c22046.scon)
	e3:SetOperation(c22046.sop)
	c:RegisterEffect(e3)
end
function c22046.synfilter(c)
	return c:IsRace(RACE_FIEND) or c:IsSetCard(0x813)
end
function c22046.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c22046.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToDeck() and c:IsSetCard(0x177)
end
function c22046.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c22046.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c22046.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c22046.filter,tp,LOCATION_GRAVE,0,1,4,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22046.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)<=0 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c22046.scon(e,tp,eg,ep,ev,re,r,rp)
    return re:GetHandler():GetControler()==1-tp and re:GetHandler():IsType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c22046.sfilter(c)
	return c:IsSetCard(0x177) and c:IsType(TYPE_SPELL) and c:IsSSetable(true)
end
function c22046.sop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not Duel.IsExistingMatchingCard(c22046.sfilter,tp,LOCATION_DECK,0,1,nil) then return end
	Duel.Hint(HINT_CARD,0,22046)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c22046.sfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end
