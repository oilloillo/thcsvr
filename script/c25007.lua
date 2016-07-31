 
--require "expansions/nef/nef"
--小野冢小町
function c25007.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x208),1)
	c:EnableReviveLimit()
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetOperation(c25007.operation)
	c:RegisterEffect(e1)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetCondition(c25007.negcon3)
	e3:SetOperation(c25007.negop3)
	c:RegisterEffect(e3)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,1)
	e2:SetValue(c25007.aclimit)
	c:RegisterEffect(e2)
end
function c25007.negcon3(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local c=e:GetHandler()
	local flag1 = a and "攻击者"..a:GetCode().."," or "无攻击者,"
	local flag2 = d and "防守者"..d:GetCode().."," or "无防守者,"
	local flag3 = a==c and "攻击者是小町" or ""
	local flag4 = d==c and "防守者是小町" or ""
	Nef.Log(flag1..flag2..flag3..flag4)
	return a and d and (a==c or d==c)
end
function c25007.negop3(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()

	if a==nil or d==nil then return end

	local c=e:GetHandler()
	local t= a==c and d or a

	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	t:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	t:RegisterEffect(e2)
end
function c25007.filter1(c,tp)
	return c:GetOwner()==1-tp
end
function c25007.operation(e,tp,eg,ep,ev,re,r,rp)
	local d1=eg:FilterCount(c25007.filter1,nil,tp)*100
	Duel.Damage(1-tp,d1,REASON_EFFECT)
end
function c25007.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE and re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end
