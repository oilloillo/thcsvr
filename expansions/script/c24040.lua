 
--鬼符「怪力乱神」
function c24040.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c24040.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c24040.handcon)
	c:RegisterEffect(e2)
end
function c24040.cfilter(c)
	return c:IsFaceup() and c:IsCode(24010)
end
function c24040.handcon(e)
	return Duel.GetMatchingGroupCount(c24040.cfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)>0
end
function c24040.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTarget(c24040.tg)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetTarget(c24040.tg)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetValue(1)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DAMAGE_CALCULATING)
	e3:SetOperation(c24040.atkup)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c24040.tg(e,c)
	return c:IsSetCard(0x625) and c:IsLevelBelow(4)
end
function c24040.filter(c,tp)
	return c:IsSetCard(0x625) and c:IsLevelBelow(4) and c:IsControler(tp)
end
function c24040.atkup(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	if c24040.filter(a,tp) and d and a:GetAttack()<d:GetAttack() then
		e1:SetValue(d:GetAttack()+2800)
		a:RegisterEffect(e1)
	elseif d and c24040.filter(d,tp) and d:GetAttack()<a:GetAttack() then 
		e1:SetValue(a:GetAttack()+2800)
		d:RegisterEffect(e1)
	end
end
