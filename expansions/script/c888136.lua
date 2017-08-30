 
--七曜-火符「火神之光上级」
function c888136.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--damage up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetCondition(c888136.rdcon)
	e4:SetOperation(c888136.rdop)
	c:RegisterEffect(e4)
	--damage
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BATTLE_DESTROYED)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c888136.dmcon)
	e5:SetTarget(c888136.dmtg)
	e5:SetOperation(c888136.dmop)
	c:RegisterEffect(e5)
end
function c888136.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c888136.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,700,REASON_BATTLE)
end
function c888136.filter(c,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:GetPreviousControler()~=tp
end
function c888136.dmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c888136.filter,1,nil,tp)
end
function c888136.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(700)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,700)
end
function c888136.dmop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
