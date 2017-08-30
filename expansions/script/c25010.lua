 
--四季映姬·亚玛萨那度
function c25010.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(c25010.tfilter),aux.NonTuner(c25010.synfilter),1)
	c:EnableReviveLimit()
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(c25010.spr)
	--c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25010,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c25010.discon)
	e1:SetTarget(c25010.distg)
	e1:SetOperation(c25010.disop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCode(EFFECT_DISABLE)
	--c:RegisterEffect(e2)
	--Disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BATTLED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c25010.operation)
	c:RegisterEffect(e4)
	--summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e5)
	--damage
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_CHAINING)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTarget(c25010.dmtg)
	e8:SetOperation(c25010.dmop)
	c:RegisterEffect(e8)
end
function c25010.tfilter(c)
	return c:IsType(TYPE_SYNCHRO) or c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c25010.synfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x208) and c:IsRace(RACE_ZOMBIE)
end
function c25010.spr(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsPreviousLocation(LOCATION_ONFIELD) then return end
	c:RegisterFlagEffect(25010,RESET_EVENT+0x1fe0000,0,0)
end
function c25010.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c25010.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c25010.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c25010.operation(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	if not ec:IsRelateToBattle() then return end
	local bc=ec:GetBattleTarget()
	if bc and bc:IsType(TYPE_EFFECT) and bc:IsStatus(STATUS_BATTLE_DESTROYED) then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x17a0000)
	bc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0x17a0000)
	bc:RegisterEffect(e2)
	end
end
function c25010.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:IsActiveType(TYPE_MONSTER) end
	Duel.SetTargetPlayer(re:GetHandler():GetControler())
	Duel.SetTargetParam(1200)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,re:GetHandler():GetControler(),1200)
end
function c25010.dmop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
