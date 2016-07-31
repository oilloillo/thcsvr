 
--ブラネテュ―ヌ
function c70081.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c70081.target)
	e1:SetOperation(c70081.activate)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c70081.sucop)
	--c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c70081.cedop)
	e3:SetLabelObject(e2)
	--c:RegisterEffect(e3)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(70081,0))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c70081.acost)
	e4:SetTarget(c70081.atg)
	e4:SetOperation(c70081.aop)
	c:RegisterEffect(e4)
	--Activate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(70081,2))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCountLimit(1)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(c70081.etarget)
	e5:SetOperation(c70081.eactivate)
	c:RegisterEffect(e5)
end
function c70081.filter(c)
	return c:IsSetCard(0x149) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c70081.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:GetControler()==tp and c70081.filter(chkc) end
	if chk==0 then return true end
	local tc=Duel.GetTargetCount(c70081.filter,tp,LOCATION_GRAVE,0,nil)
	if tc>0 and Duel.SelectYesNo(tp,aux.Stringid(70081,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectTarget(tp,c70081.filter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end
end
function c70081.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c70081.sucfilter(c)
	return c:IsSetCard(0x149)
end
function c70081.sucop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c70081.sucfilter,1,nil) then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c70081.cedop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS) and e:GetLabelObject():GetLabel()==1 then
		Duel.SetChainLimitTillChainEnd(c70081.chainlm)
	end
end
function c70081.chainlm(e,rp,tp)
	return tp==rp
end
function c70081.afilter(c)
	return c:IsSetCard(0x149) and c:IsFaceup()
end
function c70081.acost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c70081.atg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c70081.afilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c70081.afilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c70081.afilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c70081.aop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(300)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENCE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetValue(300)
		tc:RegisterEffect(e2)
	end
end
function c70081.etarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c70081.afilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c70081.afilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c70081.afilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c70081.eactivate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetValue(c70081.efilter)
		tc:RegisterEffect(e2)
	end
end
function c70081.efilter(e,te)
	return e:GetHandlerPlayer()~=te:GetHandlerPlayer() and te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
