--诞生花
local M = c999006
local Mid = 999006
function M.initial_effect(c)
	-- deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(Mid,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(0)
	e1:SetCountLimit(1, Mid)
	e1:SetCost(M.cost)
	e1:SetTarget(M.target)
	e1:SetOperation(M.activate)
	c:RegisterEffect(e1)
	-- grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(Mid,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1, Mid)
	e2:SetCost(M.cost2)
	e2:SetTarget(M.target2)
	e2:SetOperation(M.activate2)
	c:RegisterEffect(e2)
	-- tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(Mid,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1, Mid)
	e3:SetTarget(M.target3)
	e3:SetOperation(M.activate3)
	c:RegisterEffect(e3)
end

--
function M.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end

function M.cfilter(c,e,tp)
	local lv = c:GetLevel()
	return c:IsSetCard(0xaa6) and lv > 0 and Duel.IsExistingMatchingCard(M.spfilter, tp, LOCATION_DECK, 0, 1, nil, lv+1, e, tp)
end

function M.spfilter(c,lv,e,tp)
	return c:GetLevel() == lv and c:IsCanBeSpecialSummoned(e, 0, tp, false, false, POS_FACEDOWN_DEFENCE)
end

function M.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel() ~= 100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp, LOCATION_MZONE) >- 1 and Duel.CheckReleaseGroup(tp, M.cfilter, 1, nil, e, tp)
	end
	local rg = Duel.SelectReleaseGroup(tp, M.cfilter, 1, 1, nil, e, tp)
	e:SetLabel(rg:GetFirst():GetLevel())
	Duel.Release(rg, REASON_COST)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK)
end

function M.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
	local lv = e:GetLabel()
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp, M.spfilter, tp, LOCATION_DECK, 0, 1, 1, nil, lv+1, e, tp)
	if g:GetCount() > 0 then
		Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP_DEFENSE)
	end
end

--
function M.cfilter2(c)
	return c:IsSetCard(0xaa6)
end

function M.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp, M.cfilter2, 1, nil) end
	local g = Duel.SelectReleaseGroup(tp, M.cfilter2, 1, 1, nil)
	Duel.Release(g, REASON_COST)
end

function M.filter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e, 0 ,tp, false, false)
end

function M.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and M.filter2(chkc, e, tp) end
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and Duel.IsExistingTarget(M.filter2, tp, LOCATION_GRAVE, 0, 1, nil, e, tp) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectTarget(tp, M.filter2, tp, LOCATION_GRAVE, 0, 1, 1, nil, e, tp)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, g, 1, 0, 0)
end

function M.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc = Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP)
	end
end

--
function M.filter3(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xaa6) and c:IsAbleToHand()
end

function M.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(M.filter3, tp, LOCATION_DECK, 0, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function M.activate3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp, M.filter3, tp, LOCATION_DECK, 0, 1, 1, nil)
	if g:GetCount() > 0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
		Duel.ConfirmCards(1-tp, g)
	end
end
