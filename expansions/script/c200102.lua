--天候-雾雨
function c200102.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--effdam
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_BATTLE_DAMAGE_TO_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TRUE)
	c:RegisterEffect(e2)	
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(3,200102)
	e2:SetCondition(c200102.con)
	e2:SetOperation(c200102.op)
	c:RegisterEffect(e2)
end
function c200102.con(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and bit.band(r,REASON_EFFECT)~=0 and re
end
function c200102.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetHandler():IsOnField() then
		local lp=Duel.GetLP(1-tp)
		if lp>300 then Duel.SetLP(1-tp,lp-300)
		else Duel.SetLP(1-tp,0)	end
	end
end