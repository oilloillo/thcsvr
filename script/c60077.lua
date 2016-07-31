--require "expansions/nef/dss"
--しろかみ 忘却的重生
function c60077.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x191),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--indestructable by effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(2)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x191))
	e2:SetValue(c60077.valcon)
	c:RegisterEffect(e2)
	--Disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60077,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLED)
	e3:SetCondition(c60077.condition)
	e3:SetOperation(c60077.operation)
	c:RegisterEffect(e3)
end
function c60077.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c60077.condition(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	if a==c then a=Duel.GetAttackTarget() end
	if a then e:SetLabel(a:GetOriginalCode()) end
	return a and a:IsType(TYPE_EFFECT) and a:IsRelateToBattle()
end
function c60077.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=e:GetLabel()
	if c:IsFacedown() or not c:IsRelateToBattle() then return end
	c:CopyEffect(code,RESET_EVENT+0x1fe0000,0)
end
