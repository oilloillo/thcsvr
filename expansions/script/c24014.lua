 
---废狱-地心的主人·古明地觉
function c24014.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x625),aux.NonTuner(c24014.synfilter),1)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24014,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c24014.discon)
	e1:SetTarget(c24014.distg)
	e1:SetOperation(c24014.disop)
	c:RegisterEffect(e1)
	--www
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PUBLIC)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_HAND)
	c:RegisterEffect(e2)
end
function c24014.synfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x208)
end
function c24014.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c24014.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c24014.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
