 
--生药「国士无双之药」
function c21131.initial_effect(c)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c21131.target)
	e1:SetOperation(c21131.operation)
	c:RegisterEffect(e1)
end
function c21131.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x208)
end
function c21131.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c21131.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21131.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c21131.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.RegisterFlagEffect(tp,21131,0,0,0)
	Duel.RegisterFlagEffect(1-tp,21131,0,0,0)
	local flag=Duel.GetFlagEffect(tp,21131)+Duel.GetFlagEffect(1-tp,21131)
	if flag==3 or flag==6 or flag==9 then
		local atk=g:GetFirst():GetAttack()
		if atk<0 then atk=0 end
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
	else
		e:SetCategory(CATEGORY_ATKCHANGE)
	end
end
function c21131.sfilter(c)
	return c:IsCode(21131) and c:IsSSetable()
end
function c21131.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local flag=Duel.GetFlagEffect(tp,21131)+Duel.GetFlagEffect(1-tp,21131)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if flag==3 or flag==6 or flag==9 then
			local atk=tc:GetAttack()
			if atk<0 then atk=0 end
			if Duel.Destroy(tc,REASON_EFFECT)~=0 then
				Duel.Damage(tp,atk,REASON_EFFECT)
				Duel.Damage(1-tp,atk,REASON_EFFECT)
			end
		else
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_DEFENCE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
			e1:SetValue(500)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
			e2:SetValue(500)
			tc:RegisterEffect(e2)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g=Duel.SelectMatchingCard(tp,c21131.sfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SSet(tp,g:GetFirst())
				Duel.ConfirmCards(1-tp,g)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_CANNOT_TRIGGER)
				e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				e2:SetValue(1)
				g:GetFirst():RegisterEffect(e2)	
			end
		end
	end
end
