--黄金拼图-九条可怜
function c4031101.initial_effect(c)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(4031101,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_HAND)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c4031101.condition)
	e4:SetCountLimit(1,4031101)
	e4:SetCost(c4031101.discost)
	e4:SetTarget(c4031101.target2)
	e4:SetOperation(c4031101.activate2)
	c:RegisterEffect(e4)
		--disable attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4031101,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_ATTACK)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,4031101)
	e1:SetCondition(c4031101.condition2)
	e1:SetCost(c4031101.cost)
	e1:SetOperation(c4031101.operation2)
	c:RegisterEffect(e1)

end
function c4031101.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c4031101.condition(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp 
	 then return false end
	return re:GetHandler():IsOnField() and (re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP))
end
function c4031101.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c4031101.activate2(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c4031101.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and ph~=PHASE_MAIN2 and ph~=PHASE_END
		and Duel.IsExistingMatchingCard(Card.IsAttackable,tp,0,LOCATION_MZONE,1,nil)
end
function c4031101.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c4031101.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttacker() then Duel.NegateAttack()
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ATTACK_ANNOUNCE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetOperation(c4031101.disop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c4031101.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end