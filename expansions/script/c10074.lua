 
--八意对魔法多重结界✿
function c10074.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10074,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c10074.condition1)
	e1:SetTarget(c10074.target1)
	e1:SetOperation(c10074.activate1)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10074,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c10074.condition2)
	e2:SetCost(c10074.cost)
	e2:SetTarget(c10074.target2)
	e2:SetOperation(c10074.activate2)
	c:RegisterEffect(e2)
end
function c10074.condition1(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:GetCount()==1 and tg:GetFirst():IsLocation(LOCATION_MZONE) and tg:GetFirst():IsSetCard(0x161)
		and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c10074.condition2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c10074.cfilter(c)
	return c:IsSetCard(0x161) and c:IsAbleToGraveAsCost()
end
function c10074.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10074.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c10074.cfilter,1,1,REASON_COST,nil)
end
function c10074.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		if Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 then
			Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_HAND)
		end
	end
end
function c10074.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
		if g:GetCount()==0 then return end
		local sg=g:RandomSelect(1-tp,1)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c10074.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		Duel.SetTargetPlayer(1-tp)
		Duel.SetTargetParam(1500)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1500)
	end
end
function c10074.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Damage(p,d,REASON_EFFECT)
	end
end
