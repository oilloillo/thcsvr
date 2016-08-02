--逐客令
function c51205.initial_effect(c)
     --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c51205.discon)
	e1:SetTarget(c51205.distg)
	e1:SetOperation(c51205.disop)
	c:RegisterEffect(e1)
    --act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c51205.atcon)
	e2:SetLabel(2)
	c:RegisterEffect(e2)
end
function c51205.confilter(c)
	return c:IsSetCard(0x511) and c:IsFaceup()
end
function c51205.atcon(e)
	local g=Duel.GetMatchingGroup(c51205.confilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)
	return g:GetClassCount(Card.GetAttribute)>=e:GetLabel()
end
function c51205.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
end
function c51205.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c51205.disop(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		ec:CancelToGrave()
	Duel.BreakEffect()
	local g1=Duel.SendtoDeck(ec,nil,2,REASON_EFFECT)
	if g1~=0 and not Duel.IsExistingMatchingCard(c51205.confilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,e:GetHandler()) then
	Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT)
	end
end

end