--天候-疎雨
function c200110.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c200110.con)
	e2:SetOperation(c200110.op)
	c:RegisterEffect(e2)
end	
function c200110.con(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c200110.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetHandler():IsOnField() then
		local lp=Duel.GetLP(ep)
		if lp>500 then Duel.SetLP(ep,lp-500)
		else Duel.SetLP(ep,0)	end
	end
end
	--[[damage up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetCondition(c200110.rdcon)
	e2:SetOperation(c200110.rdop)
	c:RegisterEffect(e2)
end
function c200110.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return true
end
function c200110.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev+500)
end]]