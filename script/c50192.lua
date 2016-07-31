 
--晓型驱逐舰-响
function c50192.initial_effect(c)
	local temp = 0
	while temp<6 do
		c:RegisterFlagEffect(50200,0,0,0)
		temp = temp+1
	end
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50192,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c50192.macost)
	e2:SetTarget(c50192.matg)
	e2:SetOperation(c50192.maop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e3)
	--cannot special summon
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(aux.FALSE)
	c:RegisterEffect(e4)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(50192,0))
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_BATTLED)
	e7:SetCondition(c50192.damcon)
	e7:SetOperation(c50192.damop)
	c:RegisterEffect(e7)
end
function c50192.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x514) and not c:IsHasEffect(EFFECT_EXTRA_ATTACK)
end
function c50192.macost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c50192.matg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c50192.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c50192.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c50192.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c50192.maop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
	end
end
function c50192.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle()
end
function c50192.damop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(501920,RESET_EVENT+0x1fe0000,0,0)
end
