--禁忌『禁果』
function c999407.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,999407+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c999407.drcost)
	e1:SetTarget(c999407.drtg)
	e1:SetOperation(c999407.drop)
	c:RegisterEffect(e1)
	--mamo
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c999407.cost)
	e2:SetTarget(c999407.tg)
	e2:SetOperation(c999407.op)
	c:RegisterEffect(e2)
end

c999407.DescSetName = 0xa3

function c999407.costfilter(c)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	return mt and mt.DescSetName == 0xa3 and c:IsAbleToGraveAsCost() and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end

function c999407.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999407.costfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c999407.costfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end

function c999407.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function c999407.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end

function c999407.costfilter2(c)
	return c:IsCode(999407) and c:IsAbleToRemoveAsCost()
end

function c999407.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c999407.costfilter2, tp, LOCATION_GRAVE, 0, nil)
	if chk==0 then return g:GetCount()>=2 end
	local rg=g:RandomSelect(tp,2)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end

function c999407.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end

function c999407.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:GetOwner()~=e:GetOwner()
end

function c999407.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(c999407.efilter)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
	end
end