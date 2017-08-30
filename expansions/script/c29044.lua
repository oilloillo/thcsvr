 
--响符「回音之庭」
function c29044.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_DRAW)
	e2:SetCountLimit(1)
	e2:SetCondition(c29044.condition)
	e2:SetOperation(c29044.operation)
	c:RegisterEffect(e2)
	--Atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(-500)
	c:RegisterEffect(e3)
end
function c29044.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetCurrentPhase()~=PHASE_DRAW
end
function c29044.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,29044)
	Duel.Draw(tp,1,REASON_EFFECT)
end
