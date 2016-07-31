--黑与白的魔法使✿雾雨魔理沙
function c10054.initial_effect(c)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10054,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCountLimit(1,10054)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c10054.cost)
	e1:SetOperation(c10054.operation)
	c:RegisterEffect(e1)
end
function c10054.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetTurnPlayer()==tp and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c10054.filter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK)
end
function c10054.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c10054.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if Duel.IsExistingMatchingCard(c10054.filter,tp,0,LOCATION_GRAVE,1,nil) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c10054.aclimit(e,re,tp)
	--return re:GetHandler():IsLocation(LOCATION_GRAVE)
	return re:GetActivateLocation()==LOCATION_GRAVE and not re:GetHandler():IsImmuneToEffect(e)
end
