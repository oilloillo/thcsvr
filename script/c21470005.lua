 
--妖魔书-私家版百鬼夜行绘卷
function c21470005.initial_effect(c)
	c:SetUniqueOnField(1,0,21470005)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c21470005.reset)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21470005,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c21470005.cost)
	e2:SetTarget(c21470005.tg)
	e2:SetOperation(c21470005.op)
	c:RegisterEffect(e2)
end
function c21470005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,21470005)<=1 and Duel.CheckLPCost(tp,500) end
	Duel.RegisterFlagEffect(tp,21470005,RESET_PHASE+PHASE_END,0,1)
	Duel.PayLPCost(tp,500)
end
function c21470005.filter(c)
	return c:IsSetCard(0x742) and c:IsAbleToHand() and c:IsType(TYPE_TRAP+TYPE_SPELL) and not c:IsCode(21470005)
end
function c21470005.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21470005.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21470005.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or not e:GetHandler():IsLocation(LOCATION_SZONE) or not e:GetHandler():IsFaceup() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21470005.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		local tc=g:GetFirst()
		if tc:IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,g)
			if tc:GetType()==TYPE_SPELL then --[[
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,0)
			e1:SetValue(c21470005.aclimit)
			e1:SetLabel(tc:GetCode())
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)]]
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetValue(1)
			tc:RegisterEffect(e1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_SSET)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetValue(1)
			tc:RegisterEffect(e1)
			end
			if e:GetHandler():GetTurnCounter()==0 then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetRange(LOCATION_SZONE)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetCountLimit(1)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
			e2:SetOperation(c21470005.destroy)
			e:GetHandler():RegisterEffect(e2)
			end
		end
	end
end
function c21470005.reset(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():SetTurnCounter(0)
end
function c21470005.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
function c21470005.destroy(e,tp,eg,ep,ev,re,r,rp)
	if tp~=Duel.GetTurnPlayer() then return end
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==2 then Duel.Destroy(e:GetHandler(),REASON_EFFECT) end
end