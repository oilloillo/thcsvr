 
--七曜-火符「火神之光」
--require "expansions/nef/msc"
function c22131.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--damage up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c22131.rdcon)
	e2:SetOperation(c22131.rdop)
	c:RegisterEffect(e2)
	Msc.RegScMixEffect(c)
end
function c22131.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c22131.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,500,REASON_BATTLE)
end
