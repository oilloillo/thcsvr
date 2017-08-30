 
--香霖堂
function c10011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10011,0))
	e3:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c10011.condition)
	e3:SetTarget(c10011.sctg)
	e3:SetOperation(c10011.scop)
	c:RegisterEffect(e3)
end
function c10011.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<3
end
function c10011.filter(c)
	return c:IsSetCard(0x208) and c:GetLevel()==2 and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10011.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10011.filter,tp,LOCATION_DECK,0,1,nil) and Duel.CheckLPCost(tp,500) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.PayLPCost(tp,500)
end
function c10011.scop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10011.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		local tc=g:GetFirst()
		if tc:IsLocation(LOCATION_HAND) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetTargetRange(1,0)
			e1:SetTarget(c10011.splimit)
			e1:SetLabel(tc:GetCode())
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10011.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(e:GetLabel())
end