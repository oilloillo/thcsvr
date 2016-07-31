 
--七曜-水符「水精公主」
--require "expansions/nef/msc"
function c22132.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(c22132.rdcon)
	e2:SetOperation(c22132.rdop)
	c:RegisterEffect(e2)
	Msc.RegScMixEffect(c)
end
function c22132.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c22132.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,800,REASON_EFFECT)
end
