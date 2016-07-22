--山窝『与约定者的守护之地』
function c23145.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c23145.cost)
	e1:SetTarget(c23145.target)
	e1:SetOperation(c23145.activate)
	c:RegisterEffect(e1)
end
function c23145.filter(c)
	return c:IsCode(23138) and c:IsAbleToRemoveAsCost()
end
function c23145.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23145.filter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c23145.filter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c23145.spfilter(c,e,tp)
	return c:IsSetCard(0x824) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c23145.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c23145.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c23145.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c23145.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local c1=Duel.SelectMatchingCard(tp,c23145.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local c2=Duel.SelectMatchingCard(tp,c23145.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if c1 and c2 then
		Duel.SpecialSummonStep(c1,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
		Duel.SpecialSummonStep(c2,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
		Duel.SpecialSummonComplete()
	end
end
