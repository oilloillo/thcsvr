--三种神器 森罗万晶
local M = c999213
local Mid = 999213
function M.initial_effect(c)
	-- fusion
	aux.AddFusionProcCodeFun(c, 999202, M.ffilter, 2, true, true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(M.sprcon)
	e1:SetOperation(M.sprop)
	e1:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e1)
	-- sp
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetDescription(aux.Stringid(Mid, 0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1, Mid)
	e2:SetCost(M.spcost)
	e2:SetTarget(M.sptg)
	e2:SetOperation(M.spop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(Mid, ACTIVITY_SPSUMMON, M.counterfilter)
end

function M.ffilter(c)
	return c:IsType(TYPE_DUAL) and c:IsFusionSetCard(0xaa1)
end

function M.spfilter1(c, tp, fc)
	local flag = Duel.GetLocationCountFromEx(tp, tp, c) < 1
	return c:IsCode(999202) and c:IsAbleToDeckAsCost() and c:IsCanBeFusionMaterial(fc)
		and Duel.IsExistingMatchingCard(M.spfilter2, tp, LOCATION_MZONE+LOCATION_EXTRA, 0, 1, nil, fc, flag, c)
end

function M.spfilter2(c, fc, flag, c1)
	if c == c1 then return false end
	flag = flag and Duel.GetLocationCountFromEx(tp, tp, c) < 1
	return (c:IsType(TYPE_DUAL) and c:IsFusionSetCard(0xaa1)) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToDeckAsCost()
		and Duel.IsExistingMatchingCard(M.spfilter3, tp, LOCATION_MZONE+LOCATION_EXTRA, 0, 1, nil, fc, flag, c1, c)
end

function M.spfilter3(c, fc, flag, c1, c2)
	if c == c1 or c == c2 then return false end
	if flag and Duel.GetLocationCountFromEx(tp, tp, c) < 1 then return false end
	return (c:IsType(TYPE_DUAL) and c:IsFusionSetCard(0xaa1)) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToDeckAsCost()
end

function M.sprcon(e, c)
	if c == nil then return true end 
	local tp = c:GetControler()
	return Duel.IsExistingMatchingCard(M.spfilter1, tp, LOCATION_MZONE+LOCATION_EXTRA, 0, 1, nil, tp, c)
end

function M.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	local g1 = Duel.SelectMatchingCard(tp, M.spfilter1, tp, LOCATION_MZONE + LOCATION_EXTRA, 0, 1, 1, nil, tp, c)
	local c1 = g1:GetFirst()
	local flag = Duel.GetLocationCountFromEx(tp, tp, c1) < 1

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2 = Duel.SelectMatchingCard(tp, M.spfilter2, tp, LOCATION_MZONE+LOCATION_EXTRA, 0, 1, 1, nil, c, flag, c1)
	local c2 = g2:GetFirst()
	flag = flag and Duel.GetLocationCountFromEx(tp, tp, c2) < 1
	g1:Merge(g2)

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g3 = Duel.SelectMatchingCard(tp, M.spfilter3, tp, LOCATION_MZONE+LOCATION_EXTRA, 0, 1, 1, nil, c, flag, c1, c2)
	g1:Merge(g3)

	local tc = g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp, tc) end
		tc = g1:GetNext()
	end
	Duel.SendtoDeck(g1, nil, 2, REASON_COST)
end

function M.spfilter4(c, e, tp)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0xaa1) or c:IsType(TYPE_DUAL)) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function M.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local aspc = Duel.GetCustomActivityCount(Mid, tp, ACTIVITY_SPSUMMON)
	if chk==0 then return aspc==nil or aspc==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1, 0)
	e1:SetTarget(M.sumlimit)
	Duel.RegisterEffect(e1, tp)
end

function M.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and Duel.IsExistingMatchingCard(M.spfilter4, tp, LOCATION_DECK + LOCATION_GRAVE, 0, 1, nil, e, tp) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, 0, 0)
end

function M.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft = Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft < 1 then return end
	local g = Duel.GetMatchingGroup(M.spfilter4, tp, LOCATION_DECK + LOCATION_GRAVE, 0, nil, e, tp)
	local count = g:GetCount()
	if count < 1 then return end
	local min = math.min(count, ft)
	local sg = Duel.SelectMatchingCard(tp, M.spfilter4, tp, LOCATION_DECK + LOCATION_GRAVE, 0, min, ft, nil, e, tp)
	Duel.SpecialSummon(sg, 0, tp, tp, false, false, POS_FACEUP)

	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0, 1)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1, tp)
end

function M.counterfilter(c)
	return c:IsSetCard(0xaa1) or c:IsType(TYPE_DUAL)
end

function M.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsSetCard(0xaa1) or c:IsType(TYPE_DUAL))
end