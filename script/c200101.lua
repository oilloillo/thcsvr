--天候-快晴
function c200101.initial_effect(c)	
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--direct
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c200101.con)
	e1:SetTarget(aux.TRUE)
	c:RegisterEffect(e1)	
	--efftg
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c200101.con)
	e2:SetTarget(aux.TRUE)
	e2:SetValue(c200101.val)
	c:RegisterEffect(e2)	
	--[[indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetCountLimit(1)
	e3:SetValue(c200101.valcon)
	c:RegisterEffect(e3)]]
end
function c200101.filter(c)
	local x=c:GetOriginalCode()
	return ((x>=200001 and x<=200020) or (x==25016))
end
function c200101.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(aux.TRUE,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)==1
	and Duel.GetMatchingGroupCount(c200101.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)==1
end
function c200101.val(e,re,rp)
	return rp~=e:GetOwnerPlayer()
end--[[
function c200101.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end]]