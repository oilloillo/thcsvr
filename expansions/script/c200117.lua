--天候-钻石星尘
function c200117.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(c200117.operation)
	c:RegisterEffect(e1)
end
function c200117.filter1(c,tp)
	return c:IsType(TYPE_MONSTER)
end
function c200117.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsOnField() then return end
	local d1=eg:FilterCount(c200117.filter1,nil,tp)*100
	if d1>0 then Duel.Damage(1-tp,d1,REASON_EFFECT) end
end