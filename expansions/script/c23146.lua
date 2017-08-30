--牙符『杀戮游戏』
function c23146.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c23146.cost)
	e1:SetTarget(c23146.target)
	e1:SetOperation(c23146.activate)
	c:RegisterEffect(e1)
end
function c23146.filter(c)
	return c:IsCode(23139) and c:IsAbleToRemoveAsCost()
end
function c23146.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23146.filter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c23146.filter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c23146.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c23146.activate(e,tp,eg,ep,ev,re,r,rp)
	--atkup
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_DAMAGE_CALCULATING)
	e2:SetOperation(c23146.atkop)
	Duel.RegisterEffect(e2,tp)
end
function c23146.atkop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:GetControler()~=tp or not a:IsSetCard(0x824) or not d then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(-1500)
	d:RegisterEffect(e1)
end
