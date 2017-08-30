--百万同一鬼✿伊吹萃香
local M = c999703
local Mid = 999703
function M.initial_effect(c)
	-- sp 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(Mid, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(M.sptg)
	e1:SetOperation(M.spop)
	e1:SetCountLimit(1, Mid*10+1)
	c:RegisterEffect(e1)
	-- sp2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(Mid, 1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(M.cost)
	e2:SetTarget(M.target)
	e2:SetOperation(M.operation)
	e2:SetCountLimit(1, Mid*10+2)
	c:RegisterEffect(e2)
end

function M.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xaa5)
end

function M.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and M.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(M.filter, tp, LOCATION_MZONE, 0, 1, nil) 
		and e:GetHandler():IsCanBeSpecialSummoned(e, 0, tp, false, false, POS_FACEUP) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FACEUP)
	Duel.SelectTarget(tp, M.filter, tp, LOCATION_MZONE, 0, 1, 1, nil)
end

function M.spop(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local lv = tc:IsType(TYPE_XYZ) and tc:GetRank() or tc:GetLevel()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_CHANGE_LEVEL)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(lv)
		c:RegisterEffect(e2)
	end
end

function M.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaa5)
end

function M.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk==0 then return c:IsReleasable() and Duel.CheckReleaseGroup(tp, M.cfilter, 1, c) end
	local g = Duel.SelectReleaseGroup(tp, M.cfilter, 1, 1, c)
	g:AddCard(c)
	Duel.Release(g, REASON_COST)
end

function M.spfilter(c, ctype, e, tp)
	return c:IsSetCard(0xaa5) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false, POS_FACEUP) and c:IsType(ctype)
end

function M.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(M.spfilter, tp, LOCATION_GRAVE, 0, 1, nil, TYPE_SYNCHRO, e, tp)
	and Duel.IsExistingMatchingCard(M.spfilter, tp, LOCATION_GRAVE, 0, 1, nil, TYPE_XYZ, e, tp) end
end

function M.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1 = Duel.GetMatchingGroup(M.spfilter, tp, LOCATION_GRAVE, 0, nil, TYPE_SYNCHRO, e, tp)
	local g2 = Duel.GetMatchingGroup(M.spfilter, tp, LOCATION_GRAVE, 0, nil, TYPE_XYZ, e, tp)
	if g1:GetCount() < 1 or g2:GetCount() < 1 then return end
	local sg1 = g1:GetMaxGroup(Card.GetLevel)
	local sg2 = g2:GetMaxGroup(Card.GetRank)
	local sg = sg1:Select(tp, 1, 1, nil)
	local g = sg2:Select(tp, 1, 1, nil)
	sg:Merge(g)
	Duel.SpecialSummon(sg, 0, tp, tp, false, false, POS_FACEUP)
end