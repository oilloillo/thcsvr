--爆裂之草莓十字
function c13052.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c13052.condition)
	e1:SetCost(c13052.cost)
	e1:SetTarget(c13052.target)
	e1:SetOperation(c13052.activate)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c13052.condition2)
	e3:SetTarget(c13052.target2)
	e3:SetOperation(c13052.operation)
	c:RegisterEffect(e3)
	--sol
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetTarget(c13052.thtg)
	e2:SetOperation(c13052.thop)
	c:RegisterEffect(e2)
end
function c13052.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c13052.cost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c13052.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function c13052.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsAttackable() and not tc:IsStatus(STATUS_ATTACK_CANCELED) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c13052.condition2(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOnField() and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsControler(1-tp)
end
function c13052.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return re:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function c13052.operation(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c13052.tgfilter(c)
	return c:IsDestructable()
end
function c13052.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,0)
end
function c13052.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c13052.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		sg=g:RandomSelect(tp,1)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
