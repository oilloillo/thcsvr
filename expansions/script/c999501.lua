--妖精☆大暴走
local M = c999501
local Mid = 999501
function M.initial_effect(c)
	--Activate
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, Mid+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(M.cost)
	e1:SetTarget(M.target)
	e1:SetOperation(M.operation)
	c:RegisterEffect(e1)
	if not M.global_check then
		M.global_check=true
		local ge1 = Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(M.checkop)
		Duel.RegisterEffect(ge1, 0)
		local ge2 = Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(M.clear)
		Duel.RegisterEffect(ge2, 0)
	end

	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetDescription(aux.Stringid(Mid, 0))
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(M.drcost)
	e2:SetTarget(M.drtg)
	e2:SetOperation(M.drop)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
end

function M.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:GetReasonEffect():IsHasType(EFFECT_TYPE_ACTIONS) and not tc:IsSetCard(0x999) then
			M[tc:GetSummonPlayer()]=false
		end
		tc=eg:GetNext()
	end
end

function M.clear(e,tp,eg,ep,ev,re,r,rp)
	M[0]=true
	M[1]=true
end

function M.costfilter(c)
	return (c:IsCode(25020) or c:IsCode(25021) or c:IsCode(25022)) and c:IsAbleToRemoveAsCost()
end

function M.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g = Duel.GetMatchingGroup(M.costfilter, tp, LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE, 0, nil)
	if chk == 0 then return g:GetCount() >= 2 and M[tp] end
	local rg = g:Select(tp, 2, 2, nil)
	if e:GetLabelObject() then e:GetLabelObject():DeleteGroup() end
	e:SetLabelObject(rg)
	rg:KeepAlive()
	Duel.Remove(rg,POS_FACEUP,REASON_COST)

	local e1 = Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(M.splimit)
	Duel.RegisterEffect(e1, tp)
end

function M.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return se:IsHasType(EFFECT_TYPE_ACTIONS) and not c:IsSetCard(0x999)
end

function M.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local lpz = Duel.GetFieldCard(tp, LOCATION_PZONE, 0)
	local rpz = Duel.GetFieldCard(tp, LOCATION_PZONE, 1)
	if chk == 0 then return lpz == nil and rpz == nil end
end

function M.operation(e,tp,eg,ep,ev,re,r,rp)
	local lpz = Duel.GetFieldCard(tp, LOCATION_PZONE, 0)
	local rpz = Duel.GetFieldCard(tp, LOCATION_PZONE, 1)
	if lpz or rpz then return end

	local rg = e:GetLabelObject()
	local fc = rg:GetFirst()
	while fc do
		local code = fc:GetCode() - 25020 + 999502
		local token = Duel.CreateToken(tp, code)
		Duel.MoveToField(token, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
		fc = rg:GetNext()
	end
end

function M.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk == 0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c, nil, 2, REASON_COST)
	
end

function M.drfilter(c)
	return c:IsDestructable() and c:IsSetCard(0x999) and c:GetSequence()>5
end

function M.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(M.drfilter, tp, LOCATION_SZONE, 0, 1, nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 1)
end

function M.drop(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetMatchingGroup(M.drfilter, tp, LOCATION_SZONE, 0, nil)
	Duel.Destroy(g, REASON_EFFECT)
	local p, d= Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
	Duel.Draw(p, d, REASON_EFFECT)
end