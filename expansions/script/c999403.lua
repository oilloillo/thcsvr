--禁弹『星弧破碎』
local M = c999403
local Mid = 999403
function M.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(M.target)
	e1:SetOperation(M.activate)
	c:RegisterEffect(e1)
	--lvdown
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(Mid,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1c0)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(M.lvcost)
	e2:SetCondition(M.lvcon)
	e2:SetOperation(M.lvop)
	c:RegisterEffect(e2)
end

M.DescSetName = 0xa3 

function M.filter(c)
	return not c:IsPosition(POS_FACEUP_DEFENSE) and not c:IsType(TYPE_LINK)
end

function M.deffilter(c)
	return c:GetDefense() > 0 and c:IsFaceup()
end

function M.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(M.filter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil) end
	local g = Duel.GetMatchingGroup(M.filter, tp, LOCATION_MZONE, LOCATION_MZONE, nil)
	Duel.SetOperationInfo(0, CATEGORY_POSITION, g, g:GetCount(), 0, 0)
end

function M.activate(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local g = Duel.GetMatchingGroup(M.filter, tp, LOCATION_MZONE, LOCATION_MZONE, nil)
	Duel.ChangePosition(g, POS_FACEUP_DEFENSE)

	if Duel.IsExistingMatchingCard(M.thfilter, tp, LOCATION_MZONE, 0, 1, nil) then
		Duel.BreakEffect()
		local defg = Duel.GetMatchingGroup(M.deffilter, tp, LOCATION_MZONE, LOCATION_MZONE, nil)
		if defg:GetCount()>0 then
			local tc = defg:GetFirst()
			while tc do
				local e1 = Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_DEFENSE)
				e1:SetValue(0)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				tc = defg:GetNext()
			end
		end
	end
end

function M.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(), POS_FACEUP, REASON_COST)
end

function M.thfilter(c)
	return c:IsSetCard(0x815)
end

function M.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsType, tp, LOCATION_MZONE+LOCATION_HAND, LOCATION_MZONE, 1, nil, TYPE_MONSTER)
end

function M.costfilter(c)
	return c:IsCode(Mid) and c:IsAbleToRemoveAsCost()
end

function M.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g = Duel.GetMatchingGroup(M.costfilter, tp, LOCATION_GRAVE, 0, nil)
	local rep = Duel.GetFlagEffect(tp, 999410)
	local num = 2 - rep
	if num < 1 then num = 1 end
	if chk == 0 then return g:GetCount() >= num end
	local rg = g:RandomSelect(tp, num)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	Duel.ResetFlagEffect(tp, 999410)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CONFIRM)
end

function M.lvop(e,tp,eg,ep,ev,re,r,rp)
	local e1 = Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE, LOCATION_HAND+LOCATION_MZONE)
	e1:SetValue(-2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1, tp)
end