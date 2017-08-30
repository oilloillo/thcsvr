--实符「暖色的收获」
function c999308.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetDescription(aux.Stringid(999308,0))
	e1:SetCost(c999308.cost)
	e1:SetTarget(c999308.tg)
	e1:SetOperation(c999308.op)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c999308.tokentg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c999308.tokentg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end

c999308.DescSetName=0xa2

function c999308.tokentg(e,c)
	return c:IsCode(999300) and c:IsAttackPos()
end

function c999308.filter(c)
	return c:IsRace(RACE_PLANT) and c:IsFaceup()
end

function c999308.intg(e,c)
	return c:IsRace(RACE_PLANT)
end

function c999308.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) 
		and Duel.IsExistingMatchingCard(c999308.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.PayLPCost(tp,800)
end

function c999308.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	return true
end

function c999308.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetTarget(c999308.intg)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetTarget(c999308.intg)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetValue(1)
	Duel.RegisterEffect(e2,tp)
end