 
--辉针之城
function c29030.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_REVERSE_UPDATE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(c29030.condicktion)
	c:RegisterEffect(e2)
	--Destroy effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c29030.desrepcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c29030.condicktion(e)
	return e:GetHandler():IsFaceup() and e:GetHandler():IsLocation(LOCATION_SZONE) and not e:GetHandler():IsDisabled()
end
function c29030.filter(c)
	return c:IsFaceup() and c:GetAttack()<=400
end
function c29030.desrepcon(e)
	return Duel.IsExistingMatchingCard(c29030.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end