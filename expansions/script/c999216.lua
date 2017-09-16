--太阳神的系谱
local M = c999216
local Mid = 999216
function M.initial_effect(c)
	-- fusion
	aux.AddFusionProcCode2(c, 999211, 999214, false, false)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(M.sprcon)
	e1:SetOperation(M.sprop)
	e1:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(M.recon)
	e2:SetOperation(M.reop)
	c:RegisterEffect(e2)
end

function M.spfilter1(c, code, tp)
	local flag = Duel.GetLocationCountFromEx(tp, tp, c) < 1
	return c:IsFusionCode(code) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(M.spfilter2, tp, LOCATION_MZONE, 0, 1, c, 999214, tp, flag)
end

function M.spfilter2(c, code, tp, flag)
	if flag and Duel.GetLocationCountFromEx(tp, tp, c) < 1 then return false end
	return c:IsFusionCode(code) and c:IsAbleToGraveAsCost()
end

function M.sprcon(e, c)
	if c == nil then return true end 
	local tp = c:GetControler()
	return Duel.IsExistingMatchingCard(M.spfilter1, tp, LOCATION_MZONE, 0, 1, nil, 999211, tp)
end

function M.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
	local g1 = Duel.SelectMatchingCard(tp, M.spfilter1, tp, LOCATION_MZONE, 0, 1, 1, nil, 999211, tp)
	local flag = Duel.GetLocationCountFromEx(tp, tp, g1:GetFirst()) < 1

	local g2 = Duel.SelectMatchingCard(tp, M.spfilter2, tp, LOCATION_MZONE, 0, 1, 1, nil, 999214, tp, flag)
	g1:Merge(g2)
	Duel.SendtoGrave(g1, REASON_COST)
end

function M.refilter(c)
	return not c:IsAttribute(ATTRIBUTE_LIGHT)
end

function M.recon(e, c)
	return e:GetHandler():GetSummonType() == SUMMON_TYPE_FUSION
end

function M.reop(e,tp,eg,ep,ev,re,r,rp,c)
	local loc = LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA
	local rg = Duel.GetMatchingGroup(M.refilter, tp, loc, loc, nil)
	Duel.Remove(rg, POS_FACEDOWN, REASON_EFFECT)
end