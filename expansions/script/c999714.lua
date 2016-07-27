--萃鬼『天手力男之投』
local M = c999714
local Mid = 999714
function M.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	-- tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(Mid, 0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCountLimit(1, EFFECT_COUNT_CODE_SINGLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(M.tg1)
	e2:SetOperation(M.op1)
	c:RegisterEffect(e2)
	-- sp
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(Mid, 1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1, EFFECT_COUNT_CODE_SINGLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(M.tg2)
	e3:SetOperation(M.op2)
	c:RegisterEffect(e3)
	-- sp
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(Mid, 2))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1, EFFECT_COUNT_CODE_SINGLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(M.tg3)
	e4:SetOperation(M.op3)
	c:RegisterEffect(e4)
end

function M.filter(c)
	return c:IsSetCard(0xaa5) and c:IsFaceup()
end

function M.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable, tp, LOCATION_HAND, 0, 1, e:GetHandler()) 
		and Duel.IsExistingMatchingCard(M.filter, tp, LOCATION_ONFIELD, 0, 1, e:GetHandler()) end
end

function M.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp, Card.IsDiscardable, tp, LOCATION_HAND, 0, 1, 1, c)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g, REASON_EFFECT+REASON_DISCARD)
		local token=Duel.CreateToken(tp, 999710)
		Duel.SendtoHand(token, tp, REASON_EFFECT)
	end
end

function M.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHandAsCost, tp, LOCATION_ONFIELD, 0, 1, e:GetHandler()) 
		and Duel.IsExistingMatchingCard(M.filter, tp, LOCATION_ONFIELD, 0, 1, e:GetHandler()) end
end

function M.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp, Card.IsAbleToHandAsCost, tp, LOCATION_ONFIELD, 0, 1, 1, c)
	if g:GetCount()>0 then
		Duel.SendtoHand(g, 1-tp, REASON_EFFECT)
		Duel.Damage(1-tp, 1000, REASON_EFFECT)
	end
end

function M.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck, tp, LOCATION_GRAVE, 0, 1, e:GetHandler()) 
		and Duel.IsPlayerCanDiscardDeck(1-tp,2) and Duel.IsExistingMatchingCard(M.filter, tp, LOCATION_ONFIELD, 0, 1, e:GetHandler()) end
end

function M.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp, Card.IsAbleToDeck, tp, LOCATION_GRAVE, 0, 1, 1, c)
	if g:GetCount()>0 then
		Duel.DiscardDeck(1-tp, 2, REASON_EFFECT)
		Duel.SendtoDeck(g, 1-tp, 2, REASON_EFFECT)
	end
end