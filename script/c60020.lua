--白发教团的冰枪 夏尔·谢库丽特
--require "expansions/nef/nef"
function c60020.initial_effect(c)
	--pendulum summon
	local argTable = {1}
	Nef.EnablePendulumAttributeSP(c,2,aux.TRUE,argTable,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c60020.sccon)
	e2:SetTarget(c60020.splimit)
	c:RegisterEffect(e2)
	--level down
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60020,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c60020.target)
	e3:SetOperation(c60020.operation)
	c:RegisterEffect(e3)
end
function c60020.sccon(e)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return not tc or not tc:IsCode(60010)
end
function c60020.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c60020.filter(c)
	return c:IsFaceup() and not c:IsType(TYPE_XYZ) and c:IsSetCard(0x191)
end
function c60020.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60020.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c60020.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60020.filter,tp,LOCATION_MZONE,0,nil)
	local lc=g:GetFirst()
	while lc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		lc:RegisterEffect(e1)
		lc=g:GetNext()
	end
end
