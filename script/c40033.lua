 
--咒装刻印
function c40033.initial_effect(c)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c40033.target)
	e1:SetOperation(c40033.operation)
	c:RegisterEffect(e1)
end
function c40033.tcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x430) and Duel.IsExistingMatchingCard(c40033.eqfilter,c:GetControler(),0x12,0,1,nil,c)
end
function c40033.eqfilter(ec,tc)
	return ec:IsType(TYPE_EQUIP) and ec:CheckEquipTarget(tc)
end
function c40033.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:IsControler(tp) and c40033.tcfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c40033.tcfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c40033.tcfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c40033.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c40033.eqfilter,tp,0x12,0,1,1,nil,tc)
		if g:GetCount()>0 then
			Duel.Equip(tp,g:GetFirst(),tc)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetRange(LOCATION_MZONE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetValue(c40033.efilter)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetCountLimit(1)
			e2:SetRange(LOCATION_MZONE)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e2:SetOperation(c40033.op)
			e2:SetLabelObject(e:GetHandler())
			tc:RegisterEffect(e2)
		end
	end
end
function c40033.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c40033.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(-1000)
	e:GetHandler():RegisterEffect(e1)
end
