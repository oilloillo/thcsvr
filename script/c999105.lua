--远古的骗术
local M = c999105
local Mid = 999105
function M.initial_effect(c)
	if M.counter == nil then
		M.counter = true
		M[0] = 0
		M[1] = 0
		local ge0 = Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge0:SetCode(EVENT_TO_HAND)
		ge0:SetOperation(M.addcount)
		Duel.RegisterEffect(ge0, 0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(M.resetcount)
		Duel.RegisterEffect(ge1, 0)
	end
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, Mid+EFFECT_COUNT_CODE_DUEL)
	e1:SetCost(M.cost)
	e1:SetTarget(M.target)
	e1:SetOperation(M.activate)
	c:RegisterEffect(e1)
end

function M.cfilter(c, tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end

function M.resetcount(e,tp,eg,ep,ev,re,r,rp)
	M[0] = 0
	M[1] = 0
end

function M.addcount(e,tp,eg,ep,ev,re,r,rp)
	if bit.band(r, REASON_EFFECT) ~= 0 then
		if eg:IsExists(M.cfilter, 1, nil, tp) then M[tp] = 1 end
		if eg:IsExists(M.cfilter, 1, nil, 1-tp) then M[1-tp] = 1 end
	end
end

function M.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  M[tp] == 0 end
	--oath effects
	local sc = e:GetHandler()
	local e1 = Effect.CreateEffect(sc)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetTargetRange(LOCATION_DECK, 0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(function(e, c)
		return c == sc
	end)
	Duel.RegisterEffect(e1, tp)

	local e2 = Effect.CreateEffect(sc)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetCode(EFFECT_CANNOT_DRAW)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1, 0)
	Duel.RegisterEffect(e2, tp)
end

function M.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0) < 3 then return false end
		local g = Duel.GetDecktopGroup(tp, 3)
		local result = g:FilterCount(Card.IsAbleToHand, nil) > 0
		return result
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, 0, LOCATION_DECK)
end

function M.activate(e,tp,eg,ep,ev,re,r,rp)
	local p = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER)
	if Duel.GetFieldGroupCount(p, LOCATION_DECK, 0) < 3 then return end
	local g = Duel.GetDecktopGroup(p, 3)
	if g:GetCount() > 0 then
		Duel.Hint(HINT_SELECTMSG, p, HINTMSG_CONFIRM)
		local sg = g:Select(p, 1, 1, nil)
		Duel.ConfirmCards(1-p, sg)
		g:RemoveCard(sg:GetFirst())

		if Duel.SelectYesNo(1-p, aux.Stringid(Mid, 0)) then
			Duel.SendtoHand(sg, nil, REASON_EFFECT)
			Duel.Remove(g, POS_FACEDOWN, REASON_EFFECT)
		else
			Duel.SendtoHand(g, nil, REASON_EFFECT)
			Duel.Remove(sg, POS_FACEDOWN, REASON_EFFECT)
		end
	end
end
