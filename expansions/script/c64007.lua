--崩坏 布洛尼娅·扎伊切克
function c64007.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(64007,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c64007.cost)
	e1:SetTarget(c64007.target)
	e1:SetOperation(c64007.operation)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(64007,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c64007.negcon)
	e2:SetTarget(c64007.negtg)
	e2:SetOperation(c64007.negop)
	c:RegisterEffect(e2)
	--be target
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(64007,2))
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_QUICK_F)
	e3:SetCondition(c64007.condition)
	e3:SetOperation(c64007.nop)
	c:RegisterEffect(e3)
	--indestructable by effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(1)
	e4:SetCondition(c64007.condition)
	c:RegisterEffect(e4)
	--coin
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetOperation(c64007.atop)
	c:RegisterEffect(e5)
	--remove material
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(64007,3))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c64007.rmcon)
	e6:SetTarget(c64007.rmtg)
	e6:SetOperation(c64007.rmop)
	c:RegisterEffect(e6)
end
function c64007.atop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(64007,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1)
end
function c64007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c64007.filter1(c)
	return c:IsDestructable() and c:IsPosition(POS_FACEUP_ATTACK)
end
function c64007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c64007.filter1,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c64007.filter1,tp,0,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c64007.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c64007.filter1,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function c64007.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(64007)==0 and e:GetHandler():GetOverlayCount()>0
end
function c64007.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(c) and e:GetHandler():GetFlagEffect(64007)==0 and c:GetOverlayCount()>0
end
function c64007.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c64007.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function c64007.nop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
function c64007.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c64007.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
end
function c64007.rmop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end
