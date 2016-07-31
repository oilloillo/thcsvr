--山彦『扩大回音』
function c27147.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCountLimit(1,27147)
	e1:SetTarget(c27147.target1)
	e1:SetOperation(c27147.activate1)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetCountLimit(1,27147)
	e2:SetCondition(c27147.condition)
	e2:SetTarget(c27147.target2)
	e2:SetOperation(c27147.activate2)
	c:RegisterEffect(e2)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c27147.handcon)
	c:RegisterEffect(e3)
end
function c27147.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ev=Duel.GetBattleDamage(tp)
	if chk==0 then return ev>0 end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ev*2)
end
function c27147.activate1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetOperation(c27147.damop)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c27147.damop(e,tp,eg,ep,ev,re,r,rp)
	local ev=Duel.GetBattleDamage(tp)
	Duel.ChangeBattleDamage(tp,ev/2)
	Duel.Damage(1-tp,ev*2,REASON_EFFECT)
end
function c27147.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c27147.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ev*2)
end
function c27147.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,ev*2,REASON_EFFECT)
end
function c27147.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x527)
end
function c27147.handcon(e)
	return Duel.GetMatchingGroupCount(c27147.cfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)>0
end
