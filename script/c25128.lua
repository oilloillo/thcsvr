 
--怒面「愤怒的忌狼之面」
function c25128.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetTarget(c25128.target)
	e1:SetOperation(c25128.activate)
	c:RegisterEffect(e1)
end
function c25128.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x223)
end
function c25128.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:GetControler()~=tp and c25128.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c25128.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c25128.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local opt=Duel.SelectOption(tp,aux.Stringid(25128,0),aux.Stringid(25128,1))
	e:SetLabel(opt)
end
function c25128.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if e:GetLabel()==0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetValue(1000)
			tc:RegisterEffect(e1)
		else
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCode(EFFECT_IMMUNE_EFFECT)
			e2:SetValue(c25128.efilter)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		end
	end
end
function c25128.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
