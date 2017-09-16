--蛾黄之叶
local M = c999010
local Mid = 999010
function M.initial_effect(c)
	-- Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0, TIMING_END_PHASE)
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

function M.handcon(e)
	return Duel.GetTurnCount() == 1
end

function M.filter(c, tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsFaceup()
end

function M.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return M.filter(chkc, 1-tp) end
	if chk==0 then return Duel.IsExistingTarget(M.filter, tp, 0, LOCATION_MZONE, 1, nil, 1-tp) end

	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp, M.filter, tp, 0, LOCATION_MZONE, 1, 1, nil, 1-tp)
end

function M.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local c = e:GetHandler()
		--
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetDescription(aux.Stringid(Mid, 0))
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetCost(M.rmcost)
		e1:SetTarget(M.rmtg1)
		e1:SetOperation(M.rmop1)
		e1:SetLabelObject(tc)
		e1:SetLabel(tc:GetFieldID())
		e1:SetReset(RESET_EVENT+0x17a0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		--
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetDescription(aux.Stringid(Mid, 1))
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2:SetRange(LOCATION_GRAVE)
		e2:SetCost(M.rmcost)
		e2:SetTarget(M.rmtg2)
		e2:SetOperation(M.rmop2)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_EVENT+0x17a0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)

		tc:RegisterFlagEffect(Mid, RESET_EVENT+0x1fe0000, EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE, 0, 0, 
						aux.Stringid(Mid, 2))
	end
end

function M.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(), POS_FACEUP, REASON_COST)
end

function M.rmfliter(c, race)
	return c:IsType(TYPE_MONSTER) and c:IsRace(race) and c:IsAbleToRemove()
end

function M.rmtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc = e:GetLabelObject()
	if chk == 0 then 
		local flag = true
		if tc:IsLocation(LOCATION_MZONE)  and tc:IsFaceup() then
			flag = tc:GetFieldID() ~= e:GetLabel()
		end

		return tc and flag and Duel.IsExistingMatchingCard(M.rmfliter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil, tc:GetRace())
	end

	local g = Duel.GetMatchingGroup(M.rmfliter, tp, LOCATION_MZONE, LOCATION_MZONE, nil, tc:GetRace())
	Duel.SetOperationInfo(0, CATEGORY_REMOVE, g, g:GetCount(), 0, 0)
end

function M.rmop1(e,tp,eg,ep,ev,re,r,rp)
	local tc = e:GetLabelObject()
	if not tc then return end

	local g = Duel.GetMatchingGroup(M.rmfliter, tp, LOCATION_MZONE, LOCATION_MZONE, nil, tc:GetOriginalRace())
	if g:GetCount() > 0 then
		Duel.Remove(g, POS_FACEUP, REASON_EFFECT)
	end
end

function M.rmtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc = e:GetLabelObject()
	if chk == 0 then 
		return tc and eg:FilterCount(M.rmfliter, nil, tc:GetRace()) > 0
	end

	local g = eg:Filter(M.rmfliter, nil, tc:GetRace())
	Duel.SetOperationInfo(0, CATEGORY_REMOVE, g, g:GetCount(), 0, 0)
end

function M.rmop2(e,tp,eg,ep,ev,re,r,rp)
	local tc = e:GetLabelObject()
	if not tc then return end

	local g = eg:Filter(M.rmfliter, nil, tc:GetRace())
	if g:GetCount() > 0 then
		Duel.Remove(g, POS_FACEUP, REASON_EFFECT)
	end
end