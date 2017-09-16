--未来「高天原」　
local M = c999210
local Mid = 999210
function M.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCountLimit(1, Mid)
	e1:SetTarget(M.target)
	e1:SetOperation(M.operation)
	c:RegisterEffect(e1)
end

function M.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(aux.TRUE, tp, LOCATION_DECK, 0, nil) > 4 end
end

function M.filter(c)
	return c:GetCode()==999211 and c:IsAbleToHand()
end

function M.pfilter(c)
	return c:IsSetCard(0xaa1) and c:IsType(TYPE_PENDULUM)
end

function M.operation(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	Duel.ShuffleDeck(tp)
	Duel.ConfirmDecktop(tp, 5)
	local sg = Duel.GetDecktopGroup(tp, 5)
	local pg = sg:Filter(M.pfilter, nil)
	if pg:GetCount() > 0 then
		Duel.SendtoExtraP(pg, nil, REASON_EFFECT)
		Duel.BreakEffect()
		local tg=Duel.GetFirstMatchingCard(M.filter, tp, LOCATION_DECK, 0, nil)
		if tg then
			Duel.SendtoHand(tg, nil, REASON_EFFECT)
			Duel.ConfirmCards(1-tp, tg)
		end
	end
end