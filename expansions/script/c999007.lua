--深绿结界
local M = c999007
local Mid = 999007
function M.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetDescription(aux.Stringid(Mid, 0))
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(M.sptg)
	e1:SetOperation(M.spop)
	e1:SetCountLimit(1, EFFECT_COUNT_CODE_SINGLE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)

	-- to hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetDescription(aux.Stringid(Mid, 1))	
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_GRAVE+LOCATION_DECK)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1, Mid)
	e3:SetCost(M.thcost)
	e3:SetTarget(M.thtg)
	e3:SetOperation(M.thop)
	c:RegisterEffect(e3)
end

function M.spfliter(c, tp)
	return c:IsLocation(LOCATION_MZONE) and c:GetSummonPlayer() == tp and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end

function M.fusionfilter(c, e, tp, mc, chkf)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_PLANT) and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_FUSION, tp, false, false) 
		and Duel.IsExistingMatchingCard(M.matfilter, tp, LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE, 0, 1, nil, mc, c, chkf)
		and Duel.GetLocationCountFromEx(tp, tp, mc, c)
end

function M.matfilter(c, mc, fc, chkf)
	if not (c:IsCanBeFusionMaterial() and c:IsAbleToGrave()) then return false end
	local mg = Group.FromCards(mc, c)
	return fc:CheckFusionMaterial(mg, nil, chkf)
end

function M.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local chkf = Duel.GetLocationCountFromEx(tp) > 0 and PLAYER_NONE or tp
		local g = eg:Filter(M.spfliter, nil, tp)
		return g:GetCount() == 1 and Duel.IsExistingMatchingCard(M.fusionfilter, tp, LOCATION_EXTRA, 0, 1, nil, e, tp, g:GetFirst(), chkf)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
end

function M.spop(e,tp,eg,ep,ev,re,r,rp)
	local g = eg:Filter(M.spfliter, nil, tp)
	if g:GetCount() ~= 1 then return end
	local chkf = Duel.GetLocationCountFromEx(tp) > 0 and PLAYER_NONE or tp

	local mc = g:GetFirst()
	local fg = Duel.GetMatchingGroup(M.fusionfilter, tp, LOCATION_EXTRA, 0, nil, e, tp, mc, chkf)
	if fg:GetCount() > 0 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
		local fc = fg:Select(tp, 1, 1, nil):GetFirst()

		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FMATERIAL)
		local mg = Duel.SelectMatchingCard(tp, M.matfilter, tp, LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE, 0, 1, 1, nil, mc, fc, chkf)

		mg:Merge(g)
		Duel.SendtoGrave(mg, REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.SpecialSummon(fc, SUMMON_TYPE_FUSION, tp, tp, false, false, POS_FACEUP)
	end
end

--

function M.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp, 1000) end
	Duel.PayLPCost(tp, 1000)
end

function M.thfilter(c, tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0xaa6) and c:GetSummonPlayer() == tp
end

function M.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk == 0 then return eg:FilterCount(M.thfilter, nil, tp) > 0 and c:IsAbleToHand() end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, c, 1, tp, c:GetLocation())
end

function M.thop(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	if c:IsAbleToHand() and c:IsLocation(LOCATION_GRAVE+LOCATION_DECK) then
		Duel.SendtoHand(c, nil, REASON_EFFECT)
		Duel.ConfirmCards(1-tp, c)
	end
end
