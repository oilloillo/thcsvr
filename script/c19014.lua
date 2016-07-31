--境界的妖怪✿古明地觉
function c19014.initial_effect(c)

	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x214a),aux.FilterBoolFunction(Card.IsSetCard,0xa225),true)

		--negate
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(19014,1))
		e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
		e1:SetCode(EVENT_CHAINING)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e1:SetCountLimit(1)
		e1:SetCondition(c19014.negcon)
		e1:SetTarget(c19014.negtg)
		e1:SetOperation(c19014.negop)
		c:RegisterEffect(e1)

			--remove
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(19014,0))
			e2:SetCategory(CATEGORY_REMOVE)
			e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
			e2:SetType(EFFECT_TYPE_QUICK_O)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCountLimit(1)
			e2:SetCode(EVENT_FREE_CHAIN)
			e2:SetHintTiming(0,TIMING_MAIN_END)
			e2:SetCondition(c19014.condition)
			e2:SetTarget(c19014.target)
			e2:SetOperation(c19014.operation)
			c:RegisterEffect(e2)

		--tohand
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_LEAVE_FIELD)
		e3:SetOperation(c19014.setop)
		c:RegisterEffect(e3)

end


function c19014.negcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end


function c19014.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end


function c19014.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
		e:GetHandler():RegisterFlagEffect(19014,RESET_EVENT+0x1f60000,0,0)
	end
end


function c19014.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end


function c19014.filter(c)
	return c:IsAbleToRemove()
end


function c19014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c19014.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end


function c19014.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c19014.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
			e:GetHandler():RegisterFlagEffect(19014,RESET_EVENT+0x1f60000,0,0)
		end
	end
end


function c19014.thfilter(c)
	return c:IsFaceup() and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end


function c19014.setop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetFlagEffect(19014)
	if ct>0 then
		e:GetHandler():ResetFlagEffect(19014)
		Duel.Hint(HINT_CARD,0,19014)
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,c19014.thfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,ct,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,tp,REASON_EFFECT)
		end
	end
end

