--幻想时令『八节之景』
local M = c999107
local Mid = 999107
function M.initial_effect(c)
	-- cheat
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetDescription(aux.Stringid(Mid, 0))
	e0:SetHintTiming(0, TIMING_STANDBY_PHASE)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetRange(LOCATION_DECK)
	e0:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e0:SetCountLimit(1, Mid+EFFECT_COUNT_CODE_DUEL)
	e0:SetCost(M.cost)
	e0:SetTarget(M.target)
	e0:SetOperation(M.activate)
	c:RegisterEffect(e0)

	-- Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(0, TIMING_STANDBY_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, Mid+EFFECT_COUNT_CODE_DUEL)
	e1:SetTarget(M.target)
	e1:SetOperation(M.activate)
	c:RegisterEffect(e1)

	-- token
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetCondition(M.tokencon)
	e2:SetTarget(M.tokentg)
	e2:SetOperation(M.tokenop)
	c:RegisterEffect(e2)
end

function M.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGrave() end
	Duel.SendtoGrave(e:GetHandler(), REASON_COST)
end

function M.filter(c,tp)
	return c:IsCode(999104) and c:GetActivateEffect():IsActivatable(tp)
end

function M.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(M.filter, tp, LOCATION_DECK, 0, 1, nil, tp) end
end

function M.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost, tp, LOCATION_HAND, 0, 1, nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp, Card.IsAbleToDeckAsCost, tp, LOCATION_HAND, 0, 1, 1, nil)
	Duel.ConfirmCards(1-tp, g)
	Duel.SendtoDeck(g, nil, 2, REASON_COST)

	Duel.Hint(HINT_SELECTMSG, tp, aux.Stringid(Mid, 0))
	local tc = Duel.SelectMatchingCard(tp, M.filter, tp, LOCATION_DECK, 0, 1, 1, nil, tp):GetFirst()
	if tc then
		local ft = Duel.GetLocationCount(tp, LOCATION_SZONE)
		if ft > 0 then
			Duel.MoveToField(tc, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
			local te = tc:GetActivateEffect()
			local tep = tc:GetControler()
			local cost = te:GetCost()
			if cost then cost(te, tep, eg, ep, ev, re, r, rp, 1) end
			Duel.RaiseEvent(tc, EVENT_CHAIN_SOLVED, tc:GetActivateEffect(), 0, tp, tp, Duel.GetCurrentChain())

			Nef.RefreshCommonCounter(tc, 999104)
		end

		-- immune
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetCode(EFFECT_IMMUNE_EFFECT)
		e0:SetTargetRange(LOCATION_SZONE, 0)
		e0:SetTarget(M.etarget)
		e0:SetValue(M.efilter)
		Duel.RegisterEffect(e0, tp)
	end
end

function M.etarget(e, c)
	return c:IsCode(999104) and c:IsFaceup()
end

function M.efilter(e,re,rp)
	return re:GetOwnerPlayer() ~= e:GetHandlerPlayer()
end

function M.existfilter(c)
	return c:IsCode(999104) and c:IsFaceup()
end

function M.tokencon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(M.existfilter, tp, LOCATION_ONFIELD, 0, 1, nil)
end

function M.tokentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local flag = Nef.GetCommonCounter(999104, tp)
		local list = {
			[1] = {25161, 0x208, 0x4011, 2000, 2000, 5, RACE_PLANT, ATTRIBUTE_LIGHT},
			[2] = {25160, 0x208, 0x4011, 1000, 1000, 1, RACE_PLANT, ATTRIBUTE_LIGHT},
			[3] = {999300, 0x208, 0x4011,   0,    0, 2, RACE_PLANT, ATTRIBUTE_EARTH},
			[4] = {999999, 0x208, 0x4011, 900,  900, 9, RACE_AQUA, ATTRIBUTE_WATER},
		}
		return flag > 0 and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 
			and Duel.IsPlayerCanSpecialSummonMonster(tp, Nef.unpack(list[flag]))
	end
	Duel.SetOperationInfo(0, CATEGORY_TOKEN, nil, 1, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, 0, 0)
end

function M.tokenop(e,tp,eg,ep,ev,re,r,rp)
	local flag = Nef.GetCommonCounter(999104, tp)
	local list = {
		[1] = {25161, 0x208, 0x4011, 2000, 2000, 5, RACE_PLANT, ATTRIBUTE_LIGHT},
		[2] = {25160, 0x208, 0x4011, 1000, 1000, 1, RACE_PLANT, ATTRIBUTE_LIGHT},
		[3] = {999300, 0x208, 0x4011,   0,    0, 2, RACE_PLANT, ATTRIBUTE_EARTH},
		[4] = {999999, 0x208, 0x4011, 900,  900, 9, RACE_WATER, ATTRIBUTE_WATER},
	}
	local ft = Duel.GetLocationCount(tp, LOCATION_MZONE)
	local c = e:GetHandler()
	if flag > 0 and ft > 0 and Duel.IsPlayerCanSpecialSummonMonster(tp, Nef.unpack(list[flag])) then
		--
		if flag == 1 then
			local token=Duel.CreateToken(tp, 25161)
			Duel.SpecialSummonStep(token, 0, tp, tp, false, false, POS_FACEUP)
			Duel.SpecialSummonComplete()

			local d = Duel.TossDice(tp, 1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(d*100)
			token:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			token:RegisterEffect(e2)
		--
		elseif flag == 2 then
			local d = Duel.TossDice(tp, 1)
			d = math.min(d, ft)
			for i = 1, d do 
				local token = Duel.CreateToken(tp, 25160)
				Duel.SpecialSummonStep(token, 0, tp, tp, false, false, POS_FACEUP)
			end
			Duel.SpecialSummonComplete()
		--
		elseif flag == 3 then
			local token=Duel.CreateToken(tp, 999300)
			Duel.SpecialSummonStep(token, 0, tp, tp, false, false, POS_FACEUP)
			Duel.SpecialSummonComplete()

			local d = Duel.TossDice(tp, 1)
			Duel.Recover(tp, d*500, REASON_EFFECT)
		--
		elseif flag == 4 then
			local token=Duel.CreateToken(tp, 999999)
			Duel.SpecialSummonStep(token, 0, tp, tp, false, false, POS_FACEUP)
			Duel.SpecialSummonComplete()

			local d = Duel.TossDice(tp, 1)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_UPDATE_LEVEL)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			e3:SetValue(-d)
			token:RegisterEffect(e3)
		end
	end
end