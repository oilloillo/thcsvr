--瘴气「原因不明的热病」
function c24055.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e1:SetCost(c24055.cost)
	e1:SetOperation(c24055.activate)
	c:RegisterEffect(e1)
end
function c24055.filter(c)
	return c:IsCode(24004) or c:IsCode(24044)
end
function c24055.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c24055.filter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c24055.filter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c24055.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetLabel(0)
	e1:SetCondition(c24055.damcon)
	e1:SetOperation(c24055.damop)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN,3)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	e2:SetValue(300)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	e3:SetOperation(c24055.operation)
	Duel.RegisterEffect(e3,tp)
end
function c24055.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c24055.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if(ct<3) then
		ct=ct+1
		e:SetLabel(ct)
		c:SetTurnCounter(ct)
		Duel.Damage(1-tp,300,REASON_EFFECT)
	end
end
function c24055.operation(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	local rc=re:GetHandler()
	if rc:IsLocation(LOCATION_MZONE) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end
