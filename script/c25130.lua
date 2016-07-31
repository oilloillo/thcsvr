 
--忧面「杞人忧地」
function c25130.initial_effect(c)
	--destroy&remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c25130.target)
	e2:SetOperation(c25130.activate)
	c:RegisterEffect(e2)
end
function c25130.filter(c)
	return c:IsSetCard(0x414) and c:IsType(TYPE_EQUIP) and c:IsFaceup()
end
function c25130.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c25130.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c25130.filter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c25130.filter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c25130.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if Duel.SendtoGrave(tc,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(25130,0)) then
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,2,2,nil)
			local opt=Duel.SelectOption(tp,aux.Stringid(25130,1),aux.Stringid(25130,2))
			if opt==0 then
				Duel.Destroy(g,REASON_EFFECT)
			else
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			end
			Duel.BreakEffect()
			Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetCode(EFFECT_CANNOT_BP)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
