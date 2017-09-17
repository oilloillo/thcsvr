--星莲船上的探宝者✿娜兹玲
local M = c999603
local Mid = 999603
function M.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetDescription(aux.Stringid(Mid, 0))
	e1:SetCountLimit(1, Mid*10+1)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(M.spcon)
	e1:SetOperation(M.spop)
	c:RegisterEffect(e1)
	--to deck top
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(Mid, 1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1, Mid*10+2)
	e2:SetTarget(M.target)
	e2:SetOperation(M.operation)
	c:RegisterEffect(e2)
end

function M.spcon(e,c)
	if c == nil then return true end
	local flag = false
	for p = 0, 1 do
		for zone = 0, 1 do
			flag = flag or (Duel.GetFieldCard(p, LOCATION_PZONE, zone) ~= nil)
			if flag then break end
		end
	end
	return flag and Duel.GetLocationCount(c:GetControler(), LOCATION_MZONE) > 0
end

function M.spop(e,tp,eg,ep,ev,re,r,rp)
	local e1 = Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetValue(1)
	e1:SetDescription(aux.Stringid(Mid, 2))
	e1:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e:GetHandler():RegisterEffect(e1)
end

function M.filter(c)
	return c:IsType(TYPE_PENDULUM) or c:IsSetCard(0x252)
end

function M.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then 
		local g = Duel.GetMatchingGroup(M.filter, tp, LOCATION_DECK, 0, nil)
		return g:GetClassCount(Card.GetCode) >= 5
	end
end

function M.operation(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetMatchingGroup(M.filter, tp, LOCATION_DECK, 0, nil)
	if not (g:GetClassCount(Card.GetCode) >= 5) then return end

	local sg1 = Group.CreateGroup()

	for i = 1, 5 do
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
		local tempg=g:Select(tp, 1, 1, nil)
		g:Remove(Card.IsCode, nil, tempg:GetFirst():GetCode())
		sg1:Merge(tempg)
		tempg:DeleteGroup()
	end
	
	Duel.ShuffleDeck(tp)

	while sg1:GetCount() > 0 do
		local tg1 = sg1:RandomSelect(tp, 1)
		local tc = tg1:GetFirst()
		Duel.MoveSequence(tc, 0)
		sg1:RemoveCard(tc)
	end
end
