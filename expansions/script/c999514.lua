--寒符『寒流』
local M = c999514
local Mid = 999514
function M.initial_effect(c)
	-- Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(M.condition)
	c:RegisterEffect(e0)

	-- reg
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(M.regcon)
	e1:SetTarget(aux.TRUE)
	e1:SetOperation(M.regop)
	c:RegisterEffect(e1)

	-- cannot attack
	local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_FIELD)
	e21:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e21:SetRange(LOCATION_SZONE)
	e21:SetTargetRange(LOCATION_MZONE, LOCATION_MZONE)
	e21:SetTarget(M.atktarget)
	c:RegisterEffect(e21)

	-- act limit
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_FIELD)
	e22:SetRange(LOCATION_SZONE)
	e22:SetCode(EFFECT_CANNOT_ACTIVATE)
	e22:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e22:SetTargetRange(1, 1)
	e22:SetValue(M.aclimit)
	c:RegisterEffect(e22)

	--maintain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(M.mtcon)
	e3:SetOperation(M.mtop)
	c:RegisterEffect(e3)
end

function M.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end

function M.regcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
end

function M.regop(e,tp,eg,ep,ev,re,r,rp)
	local c = re:GetHandler()
	if c:IsLocation(LOCATION_MZONE) and c:GetFlagEffect(Mid) == 0 then
		c:RegisterFlagEffect(Mid, RESET_EVENT+0x1fe0000, 
			EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE, 1)
	end
end

function M.atktarget(e,c)
	return c:GetFlagEffect(Mid) > 0
end

function M.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e) 
		and re:GetHandler():GetAttackAnnouncedCount() > 0
end

function M.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end

function M.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckLPCost(tp, 800) and Duel.SelectYesNo(tp,aux.Stringid(Mid, 0)) then
		Duel.PayLPCost(tp, 800)
	else
		Duel.Destroy(e:GetHandler(), REASON_COST)
	end
end