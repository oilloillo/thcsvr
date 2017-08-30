 
--先代巫女
function c10015.initial_effect(c)
	c:EnableReviveLimit()
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)
	--redirect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10015,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c10015.target)
	e3:SetOperation(c10015.operation)
	c:RegisterEffect(e3)
end
function c10015.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(tc)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	tc:RegisterEffect(e2)
end
function c10015.filter(c,e,tp)
	return c:IsFaceup() and c:IsLevelAbove(8) and (not e or c:IsRelateToEffect(e))
end
function c10015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c10015.filter,1,e:GetHandler(),nil,tp) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c10015.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c10015.filter,nil,e,tp)
	Duel.Destroy(g,REASON_EFFECT)
end
