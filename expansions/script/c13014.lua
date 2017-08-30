 
--科学信者 朝仓理香子
function c13014.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13014,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c13014.condition)
	e1:SetTarget(c13014.target)
	e1:SetOperation(c13014.operation)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13014,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetCondition(c13014.damcon)
	e2:SetTarget(c13014.damtg)
	e2:SetOperation(c13014.damop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13014,2))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(c13014.damtg)
	e3:SetOperation(c13014.damop)
	c:RegisterEffect(e3)
end
function c13014.filter(c,tp)
	return (c:IsType(TYPE_SPELL+TYPE_TRAP) or c:IsPreviousLocation(LOCATION_SZONE)) and c:GetReasonPlayer()==tp
end
function c13014.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c13014.filter,1,nil,tp)
end
function c13014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(eg:GetCount()*500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,eg:GetCount()*500)
end
function c13014.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c13014.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE)
end
function c13014.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c13014.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
