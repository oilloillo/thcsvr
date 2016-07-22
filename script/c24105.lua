--脑符『脑指纹测谎法』
function c24105.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c24105.cost)
	e2:SetTarget(c24105.target)
	e2:SetOperation(c24105.operation)
	c:RegisterEffect(e2)
end
function c24105.cffilter(c)
	return not c:IsPublic()
end
function c24105.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24105.cffilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c24105.cffilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	local ac=g:GetFirst():GetCode()
	e:SetLabel(ac)
	e:GetHandler():SetHint(CHINT_CARD,ac)
end
function c24105.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(c24105.trop)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
end
function c24105.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ac=e:GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_HAND,nil,ac)
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.ConfirmCards(tp,hg)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	else
		Duel.ShuffleHand(1-tp)
	end
	if e:GetHandler():GetFlagEffect(24105)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetCode(EFFECT_SKIP_DP)
		e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SKIP_M1)
		e2:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_OPPO_TURN)
		Duel.RegisterEffect(e2,tp)
	end
end
function c24105.trop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler()==e:GetHandler() or rp==tp then return end
	e:GetHandler():RegisterFlagEffect(24105,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
