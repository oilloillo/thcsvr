 
--剑舞姬-克蕾儿‧露裘
function c40003.initial_effect(c)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40003,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCost(c40003.cost)
	e2:SetTarget(c40003.shtg)
	e2:SetOperation(c40003.shop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c40003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,40003)==0 end
	Duel.RegisterFlagEffect(tp,40003,RESET_PHASE+PHASE_END,0,1)
end
function c40003.filter(c)
	return c:IsCode(40022) and c:IsAbleToHand()
end
function c40003.cfilter(c)
	return not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function c40003.tgfilter(c,e,tp)
	return c:IsSetCard(0x430) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40003.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40003.filter,tp,LOCATION_DECK,0,1,nil) end
	if not Duel.IsExistingMatchingCard(c40003.cfilter,tp,0xa,0,1,e:GetHandler())
		and Duel.SelectYesNo(tp,aux.Stringid(40003,1)) then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,c40003.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40003.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c40003.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
		Duel.ConfirmCards(1-tp,tc)
	end
end
