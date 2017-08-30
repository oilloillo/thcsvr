--幻想时令『四时之兆』
local M = c999104
local Mid = 999104
function M.initial_effect(c)
	Nef.CommonCounterGroup(c, Mid)
	if M.counter == nil then
		M.counter = true
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge0:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
		ge0:SetOperation(M.addcount)
		Duel.RegisterEffect(ge0, 0)
	end

	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetOperation(function (e,tp,eg,ep,ev,re,r,rp)
		Nef.RefreshCommonCounter(c, Mid)
	end)
	c:RegisterEffect(e0)

	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(Mid)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(1, 0)
	e1:SetValue(1)
	c:RegisterEffect(e1)

	-- tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(Mid, 0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCountLimit(1, Mid)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(M.target)
	e2:SetOperation(M.operation)
	c:RegisterEffect(e2)

	--season
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(M.seasonop)
	c:RegisterEffect(e3)
end

function M.addcount(e,tp,eg,ep,ev,re,r,rp)
	for p = 0, 1 do
		if Nef.GetCommonCounter(Mid, p) < 4 then
			Nef.AddCommonCounter(1, Mid, p)
		else
			Nef.AddCommonCounter(-3, Mid, p)
		end
	end
end

function M.filter1(c)
	return c:IsSetCard(0x123) and c:IsAbleToHand()
end

function M.filter2(c)
	return (c:IsCode(25164) or c:IsSetCard(0x3208)) and c:IsAbleToHand()
end

function M.filter3(c)
	local list = {
		[999301] = true,
		[23001] = true,
		[999302] = true,
		[23004] = true,
	}
	return list[c:GetCode()] and c:IsAbleToHand()
end

function M.filter4(c)
	return c:IsSetCard(0xaa4) and c:IsAbleToHand()
end

function M.filter(c, code)
	return c:IsCode(code) and c:IsAbleToHand()
end

function M.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then
		local flag = Nef.GetCommonCounter(Mid, tp)
		local list = {20200, 22400, 23300, 10100}
		return flag > 0 and Duel.IsExistingMatchingCard(M["filter"..flag], tp, LOCATION_DECK, 0, 1, nil) 
			and Duel.IsExistingMatchingCard(M.filter, tp, LOCATION_DECK, 0, 1, nil, list[flag])
	end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 2, tp,LOCATION_DECK)
end

function M.operation(e,tp,eg,ep,ev,re,r,rp)
	local flag = Nef.GetCommonCounter(Mid, tp)
	local list = {20200, 22400, 23300, 10100}
	if flag > 0 and Duel.IsExistingMatchingCard(M["filter"..flag], tp, LOCATION_DECK, 0, 1, nil) 
		and Duel.IsExistingMatchingCard(M.filter, tp, LOCATION_DECK, 0, 1, nil, list[flag]) then
		local sg1 = Duel.SelectMatchingCard(tp, M["filter"..flag], tp, LOCATION_DECK, 0, 1, 1, nil)
		local sg2 = Duel.SelectMatchingCard(tp, M.filter, tp, LOCATION_DECK, 0, 1, 1, nil, list[flag])
		local tc = sg1:GetFirst()
		sg1:Merge(sg2)
		Duel.SendtoHand(sg1, tp, REASON_EFFECT)
		if tc:IsType(TYPE_MONSTER) and tc:GetLevel() < 3 and tc:IsCanBeSpecialSummoned(e, 0, tp, false, false) 
			and Duel.SelectYesNo(tp, aux.Stringid(Mid, 5)) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function M.seasonop(e,tp,eg,ep,ev,re,r,rp)
	if not re:GetHandler() then return end
	if re:GetHandler():GetControler()~=e:GetHandler():GetControler() then return end
	local code=re:GetHandler():GetOriginalCode()
	local list = {
		[20200] = 1,
		[22400] = 2, 
		[23300] = 3, 
		[10100] = 4,
	}
	if list[code] then
		Nef.SetCommonCounter(list[code], Mid, tp)
	end
end