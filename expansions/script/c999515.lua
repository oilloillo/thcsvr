--银色结晶
local M = c999515
local Mid = 999515
function M.initial_effect(c)
	-- Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(M.target)
	e1:SetOperation(M.activate)
	c:RegisterEffect(e1)

	-- act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(M.handcon)
	c:RegisterEffect(e2)
end

function M.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then 
		local g = Duel.GetMatchingGroup(M.desfilter, tp, LOCATION_MZONE, LOCATION_MZONE, nil)
		local ming = g:GetMinGroup(M.lvfilter)
		local tc = ming:GetFirst()
		return tc and tc:IsDestructable()
	end
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, nil, 1, 0, 0)
end

function M.thfilter(c)
	local code = {
		[999511] = true,
		[999512] = true,
		[999514] = true,
	}
	return code[c:GetCode()] and c:IsAbleToHand()
end

function M.desfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_LINK)
end

function M.activate(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetMatchingGroup(M.desfilter, tp, LOCATION_MZONE, LOCATION_MZONE, nil)
	local ming = g:GetMinGroup(M.lvfilter)

	local sg = ming:FilterSelect(tp, Card.IsDestructable, 1, 1, nil)
	if sg:GetCount() < 1 then return end

	local tc = sg:GetFirst()
	if tc and tc:IsDestructable() then
		if Duel.Destroy(tc, REASON_EFFECT) > 0 and M.lvfilter(tc) <= Duel.GetTurnCount()
			and Duel.IsExistingMatchingCard(M.thfilter, tp, LOCATION_DECK, 0, 1, nil) 
			and Duel.SelectYesNo(tp, aux.Stringid(Mid, 1)) then

			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
			local g = Duel.SelectMatchingCard(tp, M.thfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
			if g:GetCount() > 0 then
				Duel.SendtoHand(g, nil, REASON_EFFECT)
				Duel.ConfirmCards(1-tp, g)
			end
		end
	end
end

function M.lvfilter(c)
	if c:IsType(TYPE_XYZ) then 
		return c:GetRank()
	else
		return c:GetLevel()
	end
end

function M.handfilter(c, turn)
	return M.lvfilter(c) > turn
end

function M.handcon(e)
	return Duel.IsExistingMatchingCard(M.desfilter, 0, LOCATION_MZONE, LOCATION_MZONE, 1, nil)
		and not Duel.IsExistingMatchingCard(M.handfilter, 0, LOCATION_MZONE, LOCATION_MZONE, 1, nil, Duel.GetTurnCount())
end