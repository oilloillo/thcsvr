--弱小的植物妖怪 濑笈叶
local M = c999004
local Mid = 999004
function M.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetDescription(aux.Stringid(Mid, 0))
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCode(EVENT_CHAINING)
	e1:SetTarget(M.target)
	e1:SetOperation(M.operation)
	e1:SetCountLimit(1, Mid*10+1)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetDescription(aux.Stringid(Mid, 1))
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(M.healcost)
	e2:SetTarget(M.healtg)
	e2:SetOperation(M.healop)
	e2:SetCountLimit(1, Mid*10+2)
	c:RegisterEffect(e2)
end

function M.filter(c, e, tp, mg, chkf)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_FUSION, tp, false, false) 
		and c:CheckFusionMaterial(mg, nil, chkf) and Duel.GetLocationCountFromEx(tp, tp, mg, c) > 0
end

function M.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	local c=e:GetHandler()
	local chkf = Duel.GetLocationCountFromEx(tp) > 0 and PLAYER_NONE or tp
	if chk==0 then return rc and c and ep == tp and rc:IsAbleToDeck() and c:IsAbleToDeck() 
		and Duel.IsExistingMatchingCard(M.filter, tp, LOCATION_EXTRA, 0, 1, nil, e, tp, Group.FromCards(rc, c), chkf) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
end

function M.operation(e,tp,eg,ep,ev,re,r,rp)
	local rc = re:GetHandler()
	local c = e:GetHandler()
	local chkf = Duel.GetLocationCountFromEx(tp) > 0 and PLAYER_NONE or tp
	if not rc or not c then return end
	local mg = Group.FromCards(rc, c)
	if ep == tp and rc:IsAbleToDeck() and c:IsAbleToDeck() and Duel.IsExistingMatchingCard(M.filter, tp, LOCATION_EXTRA, 0, 1, nil, e, tp, Group.FromCards(rc, c), chkf) then
		local g = Duel.SelectMatchingCard(tp, M.filter, tp, LOCATION_EXTRA, 0, 1, 1, nil, e, tp, Group.FromCards(rc, c), chkf)
		Duel.SendtoDeck(mg, nil, 2, REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.SpecialSummon(g, SUMMON_TYPE_FUSION, tp, tp, false, false, POS_FACEUP)
	end
end

function M.healcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c, nil, 2, REASON_COST)
	
end

function M.healtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0, CATEGORY_RECOVER, nil, 0, tp, 1000)
end

function M.healop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp, 1000, REASON_EFFECT)
end