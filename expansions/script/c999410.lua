--七色之翼✿芙兰朵露
local M = c999410
local Mid = 999410
function M.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(Mid,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(M.descost)
	e1:SetTarget(M.destg)
	e1:SetOperation(M.desop)
	c:RegisterEffect(e1)
	--code
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetValue(22028)
	c:RegisterEffect(e3)
end

M.DescSetName = 0xa3

function M.costfilter(c)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	return mt and mt.DescSetName == 0xa3 and (c:IsType(TYPE_CONTINUOUS) or c:IsType(TYPE_TRAP)) and c:IsAbleToGraveAsCost()
end

function M.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(M.costfilter, tp, LOCATION_DECK, 0, 1, e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp, M.costfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
	Duel.SendtoGrave(g, REASON_COST)
end

function M.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk == 0 then return Duel.IsExistingTarget(Card.IsDestructable, tp, 0, LOCATION_DECK + LOCATION_EXTRA, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, nil, 1, 0, 0)
end

function M.desop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	local g = Duel.GetMatchingGroup(Card.IsDestructable, tp, 0, LOCATION_DECK + LOCATION_EXTRA, nil)
	local tc = g:RandomSelect(tp, 1):GetFirst()

	if Duel.Destroy(tc, REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.RegisterFlagEffect(tp, Mid, 0, 0, 1)
	end
end