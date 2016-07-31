--未来「高天原」　
--require "expansions/nef/nef"
function c999210.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetCountLimit(1,999210)
	e1:SetTarget(c999210.target)
	e1:SetOperation(c999210.operation)
	c:RegisterEffect(e1)
end
function c999210.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(aux.TRUE, tp, LOCATION_DECK, 0, nil)>4 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c999210.filter(c)
	return c:GetCode()==999211 and c:IsAbleToHand()
end
function c999210.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmDecktop(tp, 5)
	local sg=Duel.GetDecktopGroup(tp,5)
	local flag = false
	if sg:GetCount()>0 then
		local tc = sg:GetFirst()
		while tc do
			if tc:IsSetCard(0xaa1) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) 
				and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
				flag = true 
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
				if tc:IsLocation(LOCATION_MZONE) and tc:IsAbleToGrave() then 
					Duel.SendtoGrave(tc, REASON_EFFECT)
				end
			end
			tc = sg:GetNext()
		end
		if flag then 
			Duel.BreakEffect()
			-- local e3=Effect.CreateEffect(e:GetHandler())
			-- e3:SetType(EFFECT_TYPE_FIELD)
			-- e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			-- e3:SetCode(EFFECT_SKIP_DP)
			-- e3:SetTargetRange(1,0)
			-- e3:SetReset(RESET_PHASE+PHASE_END,3)
			-- Duel.RegisterEffect(e3,tp)
			local tg=Duel.GetFirstMatchingCard(c999210.filter,tp,LOCATION_DECK,0,nil)
			if tg then
				Duel.SendtoHand(tg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tg)
			end
		end
	end
end