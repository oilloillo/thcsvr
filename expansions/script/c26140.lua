--鵺符『鵺的蛇行表演』
function c26140.initial_effect(c)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26140.target)
	e1:SetOperation(c26140.operation)
	c:RegisterEffect(e1)
end
function c26140.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x251c)
end
function c26140.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c26140.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26140.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c26140.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local op=Duel.SelectOption(tp,aux.Stringid(26140,0),aux.Stringid(26140,1))
	e:SetLabel(op)
end
function c26140.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if e:GetLabel()==0 then
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_IMMUNE_EFFECT)
			e4:SetValue(c26140.efilter)
			e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e4:SetOwnerPlayer(tp)
			tc:RegisterEffect(e4)
			if Duel.GetTurnPlayer()==tp then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_ATTACK_FINAL)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				e1:SetValue(tc:GetAttack()/2)
				tc:RegisterEffect(e1)
			end
		else
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e3:SetValue(c26140.eefilter)
			c:RegisterEffect(e3,true)
			if Duel.GetTurnPlayer()~=tp then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DIRECT_ATTACK)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
				tc:RegisterEffect(e1)
			end
		end
	end
end
function c26140.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c26140.eefilter(e,re,rp)
	return e:GetHandlerPlayer()~=rp
end
