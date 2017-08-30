 
--禁忌「恋的迷路」
function c22121.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE+0x1c0)
	e1:SetOperation(c22121.operation)
	c:RegisterEffect(e1)
end
function c22121.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c22121.drop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(c22121.thcon)
	e2:SetOperation(c22121.thop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c22121.filter(c,sp)
	return c:GetSummonPlayer()==sp
end
function c22121.tgfilter(c)
	return (c:IsSetCard(0x813) or c:GetOriginalCode()==(22100) or c:GetOriginalCode()==(22117)) and c:IsAbleToGrave()
end
function c22121.thfilter(c)
	return (c:IsSetCard(0x813) or c:GetOriginalCode()==(22100) or c:GetOriginalCode()==(22117))
end
function c22121.drop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c22121.filter,1,nil,1-tp) and Duel.SelectYesNo(tp,aux.Stringid(22121,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c22121.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
			Duel.Damage(1-tp,500,REASON_EFFECT)
			local sg=Duel.GetOperatedGroup()
			local ct=sg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
			if ct~=0 then
				Duel.RegisterFlagEffect(tp,22121,RESET_PHASE+PHASE_END,0,1)
			end
		end
	end
end
function c22121.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,22121)>0
end
function c22121.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,22121)
	local g=Duel.GetMatchingGroup(c22121.thfilter,tp,LOCATION_GRAVE,0,nil)
	local tc=g:GetMaxGroup(Card.GetSequence):GetFirst()
	if tc and tc:IsAbleToHand() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(tp,tc)
	end
end
