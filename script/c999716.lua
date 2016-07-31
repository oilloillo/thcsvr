--雾符『云集雾散』
local M = c999716
local Mid = 999716
function M.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(M.condition)
	e1:SetCost(M.cost)
	e1:SetTarget(M.target)
	e1:SetOperation(M.activate)
	c:RegisterEffect(e1)
	--Activate(summon)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetCost(M.cost)
	e2:SetCondition(M.condition1)
	e2:SetTarget(M.target1)
	e2:SetOperation(M.activate1)
	c:RegisterEffect(e2)
	--
	local e3=e2:Clone()
	e2:SetCode(EVENT_SUMMON)
	c:RegisterEffect(e3)
end

function M.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end

function M.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard, 1, nil, 0xaa5) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard, 1, 1, nil, 0xaa5)
	Duel.Release(g, REASON_COST)
end

function M.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0, CATEGORY_NEGATE, eg, 1, 0, 0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0, CATEGORY_REMOVE, eg, 1, 0, 0)
	end
end

function M.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg, POS_FACEUP, REASON_EFFECT)
	end
end

function M.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end

function M.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0, CATEGORY_DISABLE_SUMMON, eg,eg:GetCount(), 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_REMOVE, eg, eg:GetCount(), 0, 0)
end

function M.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Remove(eg, POS_FACEUP, REASON_EFFECT)
end