--蓬莱子✿
function c7001000.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c7001000.target)
	e1:SetValue(c7001000.atkval)
	c:RegisterEffect(e1)
	--def
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENCE)
	e2:SetValue(c7001000.defval)
	c:RegisterEffect(e2)
end
function c7001000.target(e,c)
	return not c:IsType(TYPE_EFFECT)
end
function c7001000.atkval(e,c)
	return c:GetBaseAttack()/2
end
function c7001000.defval(e,c)
	return c:GetBaseDefence()/2
end