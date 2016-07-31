 
--红魔 艳丽的门番
function c22043.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x813),1)
	c:EnableReviveLimit()
	--destroyed
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22043,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetCondition(c22043.retcon)
	e2:SetTarget(c22043.destg)
	e2:SetOperation(c22043.desop)
	c:RegisterEffect(e2)
	--mamo
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_SZONE,0)
	e3:SetTarget(c22043.efilter)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c22043.retcon(e,tp,eg,ep,ev,re,r,rp)
	local t=e:GetHandler():GetBattleTarget()
	return t and t:IsRelateToBattle()
end
function c22043.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsLocation(LOCATION_GRAVE) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetLabelObject(),1,0,0)
end
function c22043.desop(e,tp,eg,ep,ev,re,r,rp)
	local t=e:GetHandler():GetBattleTarget()
	Duel.Destroy(t,REASON_EFFECT)
end
function c22043.efilter(e,c)
	return c:GetOriginalCode()==(22100) or c:GetOriginalCode()==(22117)
end
