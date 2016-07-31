 
--妖魔书整理
function c21470017.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0+TIMING_END_PHASE)
	e1:SetTarget(c21470017.target)
	e1:SetOperation(c21470017.activate)
	c:RegisterEffect(e1)
end
function c21470017.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet() and c:IsSetCard(0x742)
end
function c21470017.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c21470017.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21470017.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c21470017.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	if g:GetFirst():IsType(TYPE_MONSTER) then Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0) end
end
function c21470017.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if tc:IsType(TYPE_MONSTER) then 
			if tc:IsType(TYPE_TRAPMONSTER) then 
				Duel.ChangePosition(tc,POS_FACEDOWN_DEFENCE) 
				tc:RegisterFlagEffect(21470020,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
			else Duel.ChangePosition(tc,POS_FACEDOWN_DEFENCE) end
	--		Duel.Draw(tp,1,REASON_EFFECT)
		else 
			Duel.ChangePosition(tc,POS_FACEDOWN)
			Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tc:GetControler(),0) 
			tc:RegisterFlagEffect(21470020,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		end
		--[[
		local sg=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,0,LOCATION_ONFIELD,nil)
		if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(21470017,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local ss=sg:Select(tp,1,1,nil)
			Duel.HintSelection(ss)
			sc=ss:GetFirst()
			Duel.BreakEffect()
			if sc:IsType(TYPE_MONSTER) then Duel.ChangePosition(sc,POS_FACEDOWN_DEFENCE) 
			else 
				Duel.ChangePosition(sc,POS_FACEDOWN)
				Duel.RaiseEvent(sc,EVENT_SSET,e,REASON_EFFECT,tp,sc:GetControler(),0) 
			end
		end]]
	end
end