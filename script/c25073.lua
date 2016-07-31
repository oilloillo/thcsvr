--审判『最终审判』
function c25073.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c25073.cost)
	e1:SetTarget(c25073.target)
	e1:SetOperation(c25073.activate)
	c:RegisterEffect(e1)
end
function c25073.spfilter(c)
	return c:IsSetCard(0x740) and c:IsAbleToRemoveAsCost()
end
function c25073.cfilter(c)
	return c:IsReleasable() and c:IsType(TYPE_MONSTER)
end
function c25073.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c25073.spfilter,tp,0x16,0,nil)
	local rg=Duel.GetMatchingGroup(c25073.cfilter,tp,0x6,LOCATION_MZONE,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>1 and rg:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c25073.spfilter,tp,0x16,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c25073.spfilter,tp,0x16,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
	Duel.Release(rg,REASON_COST)
	local conf=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if conf:GetCount()>0 then
		Duel.ConfirmCards(1-tp,conf)
		Duel.ShuffleHand(tp)
	end
end
function c25073.filter(c,e,tp)
	return c:IsSetCard(0x740) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c25073.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-6 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetTargetPlayer(tp)
end
function c25073.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local tg=Duel.GetFieldGroup(p,0,LOCATION_HAND)
	if tg:GetCount()>0 then
		Duel.ConfirmCards(p,tg)
	end
	Duel.BreakEffect()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c25073.filter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(25073,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c25073.filter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.ShuffleHand(1-p)
	end
end
