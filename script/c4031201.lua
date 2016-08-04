--Hello!黄金拼图
function c4031201.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c4031201.cost)
	e1:SetTarget(c4031201.sctg)
	e1:SetOperation(c4031201.scop)
	c:RegisterEffect(e1)
end
function c4031201.filter(c)
	return c:IsSetCard(0x403) and c:IsAbleToDeckAsCost() and c:IsType(TYPE_MONSTER)
end
function c4031201.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4031201.filter,tp,LOCATION_REMOVED,0,5,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c4031201.filter,tp,LOCATION_REMOVED,0,5,5,nil)
	Duel.SendtoDeck(g,nil,5,REASON_COST)
end
function c4031201.filter2(c,e,tp)
	return c:IsLevelBelow(10) and c:IsType(TYPE_SYNCHRO)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c4031201.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c4031201.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c4031201.scop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c4031201.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
