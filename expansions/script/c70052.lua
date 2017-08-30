--四国教祖 伊丝多瓦露
function c70052.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(70052,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c70052.cost)
	e1:SetTarget(c70052.target)
	e1:SetOperation(c70052.operation)
	c:RegisterEffect(e1)
	--Remove&Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(70052,1))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c70052.cost)
	e1:SetTarget(c70052.rmtg)
	e1:SetOperation(c70052.rmop)
	c:RegisterEffect(e1)
end
function c70052.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c70052.filter(c)
	return c:IsCode(70081) and c:IsAbleToHand()
end
function c70052.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c70052.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c70052.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstMatchingCard(c70052.filter,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c70052.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c70052.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,1,nil)
	local tg=g:GetFirst()
	if tg==nil then return end
	Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
	tg:RegisterFlagEffect(70052,RESET_EVENT+0x1fe0000,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
	e1:SetOperation(c70052.tohand)
	e1:SetLabel(0)
	e1:SetLabelObject(tg)
	Duel.RegisterEffect(e1,tp)
end
function c70052.tohand(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return end
	local ct=e:GetLabel()
	e:GetHandler():SetTurnCounter(ct+1)
	if ct==1 then
		local tc=e:GetLabelObject()
		if tc:GetFlagEffect(70052)~=0 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	else e:SetLabel(1) end
end
