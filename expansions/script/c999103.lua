--天与地之怒
local M = c999103
local Mid = 999103
function M.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(M.cost)
	e1:SetTarget(M.target)
	e1:SetOperation(M.activate)
	c:RegisterEffect(e1)
end

function M.cfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsAbleToRemoveAsCost()
end

function M.spfilter(c, e, tp)
	return (c:IsCode(24010) or c:IsCode(10006) or c:IsCode(10008)) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
		and Duel.IsExistingMatchingCard(M.spfilter2, tp, LOCATION_EXTRA+LOCATION_DECK, 0, 1, nil, e, tp, c) 
end

function M.spfilter2(c, e, tp, tc)
	local code = tc:GetCode()
	local flag = (c:IsCode(24010) or c:IsCode(10006) or c:IsCode(10008)) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false) and not c:IsCode(code)
	if not flag then return false end

	local exft = (tc:IsLocation(LOCATION_EXTRA) and 1 or 0) + (c:IsLocation(LOCATION_EXTRA) and 1 or 0)
	local ft = 2 - exft

	return Duel.GetLocationCountFromEx(tp) >= exft and Duel.GetUsableMZoneCount(tp) - exft >= ft
end

function M.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local count = 7
	if chk == 0 then return Duel.IsExistingMatchingCard(M.cfilter, tp, LOCATION_GRAVE, 0, count, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
	local g = Duel.SelectMatchingCard(tp, M.cfilter, tp, LOCATION_GRAVE, 0, count, count, nil)
	Duel.Remove(g, POS_FACEUP, REASON_COST)
end

function M.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then return Duel.GetUsableMZoneCount(tp) > 1 
		and Duel.IsExistingMatchingCard(M.spfilter, tp, LOCATION_EXTRA+LOCATION_DECK, 0, 1, nil, e, tp) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 2, 0, 0)
end

function M.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft = Duel.GetUsableMZoneCount(tp)
	if ft > 1 and Duel.IsExistingMatchingCard(M.spfilter, tp, LOCATION_EXTRA+LOCATION_DECK, 0, 1, nil, e, tp, nil) then 
		local sg1 = Duel.SelectMatchingCard(tp, M.spfilter, tp, LOCATION_EXTRA+LOCATION_DECK, 0, 1, 1, nil, e, tp)
		local sg2 = Duel.SelectMatchingCard(tp, M.spfilter2, tp, LOCATION_EXTRA+LOCATION_DECK, 0, 1, 1, nil, e, tp, sg1:GetFirst())
		sg1:Merge(sg2)

		-- extra card spsummon first
		local g = sg1:Filter(Card.IsLocation, nil, LOCATION_EXTRA)
		Duel.SpecialSummonStep(g:GetFirst(), 0, tp, tp, false, false, POS_FACEUP)

		sg1:Sub(g)
		Duel.SpecialSummonStep(sg1:GetFirst(), 0, tp, tp, false, false, POS_FACEUP)

		Duel.SpecialSummonComplete()
	end
end