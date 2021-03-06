--禁弹『折反射』
local M = c999402
local Mid = 999402
function M.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetDescription(aux.Stringid(Mid, 0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0, 0x1e0)
	e1:SetCondition(M.con)
	e1:SetCost(M.cost)
	e1:SetOperation(M.activate)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(Mid, 1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetCondition(M.condition)
	e2:SetTarget(M.target)
	e2:SetOperation(M.operation)
	c:RegisterEffect(e2)
end

M.DescSetName = 0xa3 

function M.costfilter(c)
	return c:IsSetCard(0x815)
end

function M.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then return Duel.CheckReleaseGroup(tp, M.costfilter, 1, nil) end
	local g = Duel.SelectReleaseGroup(tp,M.costfilter, 1, 1, nil)
	Duel.Release(g, REASON_COST)
	e:SetLabel(g:GetFirst():GetAttack())
end

function M.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsType, tp, 0, LOCATION_MZONE, nil, TYPE_MONSTER) > 0
end

function M.activate(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local atk = e:GetLabel()
	while atk >= 400 do
		local mg = Duel.GetMatchingGroup(Card.IsFaceup, tp, 0, LOCATION_MZONE, nil)
		mg:AddCard(c)
		local rc = mg:RandomSelect(tp, 1):GetFirst()
		if rc == c then
			Duel.Damage(1-tp, 500, REASON_EFFECT)
		else
			local e1 = Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-800)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			rc:RegisterEffect(e1)
			local e2 = e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			rc:RegisterEffect(e2)
			if (rc:GetDefense() <= 0 and not rc:IsType(TYPE_LINK)) or rc:GetAttack() <= 0 then
				Duel.Destroy(rc, REASON_EFFECT)
			end
		end
		atk = atk - 400
	end
end

function M.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep == tp
end

function M.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then return true end
	Duel.SetOperationInfo(0, CATEGORY_REMOVE, e:GetHandler(), 1, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_DAMAGE, nil, 0, 1-tp, 1000)
end

function M.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Remove(e:GetHandler(), POS_FACEUP, REASON_EFFECT) ~= 0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp, 1000, REASON_EFFECT)
	end
end