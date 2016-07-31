 
--七曜-金符「金属疲劳」
--require "expansions/nef/msc"
function c22134.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_DEFENCE)
	e2:SetValue(-300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(-300)
	c:RegisterEffect(e3)
	Msc.RegScMixEffect(c)
end
