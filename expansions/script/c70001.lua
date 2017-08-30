 
--Neptune
function c70001.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(70001,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c70001.ntcon)
	e1:SetOperation(c70001.negop)
	c:RegisterEffect(e1)
end
function c70001.ntcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c70001.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_MAIN1)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_MAIN1)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_MAIN1)
			tc:RegisterEffect(e3)
		end
		tc=g:GetNext()
	end
end
