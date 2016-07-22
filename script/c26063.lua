--可怜的非法投弃物✿多多良小伞
function c26063.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26063,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c26063.spcost)
	e1:SetTarget(c26063.sptg)
	e1:SetOperation(c26063.spop)
	c:RegisterEffect(e1)
	--flip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26063,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FLIP)
	e2:SetTarget(c26063.target)
	e2:SetOperation(c26063.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e3:SetOperation(c26063.flipop)
	c:RegisterEffect(e3)
end
function c26063.cffilter(c,e,tp)
	return c:IsSetCard(0x229) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENCE) and not c:IsPublic()
end
function c26063.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c26063.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c26063.cffilter,tp,LOCATION_HAND,0,1,e:GetHandler(),e,tp) end
	local lt=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if lt>3 then lt=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c26063.cffilter,tp,LOCATION_HAND,0,1,lt,e:GetHandler(),e,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
	Duel.ShuffleHand(tp)
end
function c26063.spop(e,tp,eg,ep,ev,re,r,rp)
	local lt=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 and tg:GetCount()<=lt and Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEDOWN_DEFENCE)>1 then
		Duel.ShuffleSetCard(tg)
	end
end
function c26063.filter(c)
	return c:IsCode(26063) and c:IsAbleToDeck()
end
function c26063.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26063.filter,tp,LOCATION_GRAVE,0,1,nil) end
	if e:GetHandler():GetFlagEffect(26063)~=0 then
		e:SetLabel(1)
		e:GetHandler():ResetFlagEffect(26063)
	else
		e:SetLabel(0)
	end
	local g=Duel.GetMatchingGroup(c26063.filter,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c26063.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26063.filter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_DECK)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,ct,ct,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		if e:GetLabel()==1 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c26063.flipop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(26063,0,0,0)
end
