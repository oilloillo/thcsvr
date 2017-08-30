 
--荷兰人形
function c20078.initial_effect(c)
	--nagate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(c20078.condition)
	e1:SetCost(c20078.cost)
	e1:SetTarget(c20078.target)
	e1:SetOperation(c20078.nagate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e2)
	--cannot be battle target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetTarget(c20078.tg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c20078.condition(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp
		and loc==LOCATION_HAND and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
end
c20078[0]=true
c20078[1]=true
function c20078.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c20078[tp] and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	c20078[tp]=false
end
function c20078.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c20078.nagate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c20078.tg(e,c)
	return c:IsSetCard(0x300) and c:IsLevelAbove(5)
end
