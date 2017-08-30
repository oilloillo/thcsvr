--审判『有罪或无罪』
function c25072.initial_effect(c)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_LVCHANGE+CATEGORY_COIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c25072.rmcon)
	e1:SetTarget(c25072.target)
	e1:SetOperation(c25072.operation)
	c:RegisterEffect(e1)
end
function c25072.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x740) 
end
function c25072.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
		and Duel.IsExistingMatchingCard(c25072.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c25072.filter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c25072.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c25072.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c25072.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c25072.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c25072.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsFaceup() or not tc:IsRelateToEffect(e) then return end
	if Duel.TossCoin(tp,1)==1 then
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_UPDATE_LEVEL)
		e0:SetReset(RESET_EVENT+0x1fe0000)
		e0:SetValue(2)
		tc:RegisterEffect(e0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_ATTACK)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCode(EVENT_PHASE+PHASE_END)
		e4:SetOperation(c25072.desop)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e4:SetCountLimit(1)
		tc:RegisterEffect(e4)
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if g:GetCount()>0 then
			local sg=g:RandomSelect(1-tp,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		end
	else
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(-2)
		tc:RegisterEffect(e1)
		Duel.Draw(tc:GetControler(),1,REASON_EFFECT)
	end
end
function c25072.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
