--失明的夜雀
local M = c999106
local Mid = 999106
function M.initial_effect(c)
	-- Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(M.condition)
	e0:SetOperation(M.operation)
	c:RegisterEffect(e0)
end

function M.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end

function M.operation(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetLabel(Duel.GetTurnCount())
	e2:SetReset(RESET_PHASE+PHASE_END, 2)
	e2:SetOperation(M.gaineff)
	Duel.RegisterEffect(e2, tp)
end

function M.filter(c)
	return c:GetSequence() < 6
end

function M.efilter(e, re, rp)
	local tc = re:GetHandler()
	local c = e:GetHandler()
	if not tc then return false end
	if rp == e:GetHandlerPlayer() then return false end

	return not c:GetColumnGroup():IsContains(tc)
end

function M.gaineff(e,tp,eg,ep,ev,re,r,rp)
	local turn =  2 - (Duel.GetTurnCount() - e:GetLabel())
	if turn == 0 then return end

	local g = Duel.GetMatchingGroup(M.filter, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, nil)
	g:ForEach(function(c)
		if c:GetFlagEffect(Mid*100+turn) == 0 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e2:SetRange(LOCATION_ONFIELD)
			e2:SetReset(RESET_PHASE+PHASE_END, turn)
			e2:SetValue(M.efilter)
			c:RegisterEffect(e2, true)

			c:RegisterFlagEffect(Mid*100+turn, RESET_PHASE+PHASE_END, EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE, turn)
		end
	end)
end