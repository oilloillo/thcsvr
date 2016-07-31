--白发教团的火焰 安谢丽丝·谢库丽特
--require "expansions/nef/nef"
function c60010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x191))
	e2:SetValue(c60010.val)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetValue(c60010.var)
	c:RegisterEffect(e4)
	--level up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60010,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c60010.target)
	e3:SetOperation(c60010.operation)
	c:RegisterEffect(e3)
end
function c60010.val(e,c)
	return c:GetLevel()*100
end
function c60010.var(e,c)
	return c:GetRank()*100
end
function c60010.filter(c)
	return c:IsFaceup() and not c:IsType(TYPE_XYZ) and c:IsSetCard(0x191)
end
function c60010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60010.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c60010.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60010.filter,tp,LOCATION_MZONE,0,nil)
	local lc=g:GetFirst()
	while lc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		lc:RegisterEffect(e1)
		lc=g:GetNext()
	end
end
