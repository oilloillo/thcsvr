 
--绯想✿博丽灵梦
function c200001.initial_effect(c)	
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(10001)
	c:RegisterEffect(e1)
	--field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(200001,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c200001.con1)
	e1:SetOperation(c200001.op1)
	c:RegisterEffect(e1)
	--mon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(200001,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e2:SetCountLimit(1)
	e2:SetTarget(c200001.tg2)
	e2:SetOperation(c200001.op2)
	c:RegisterEffect(e2)
end
function c200001.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c200001.op1(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,200101)
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
--	Duel.RaiseEvent(token,EVENT_CHAIN_SOLVED,token:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
end
function c200001.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c200001.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) then
		c:SetCardTarget(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_OWNER_RELATE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCondition(c200001.rcon)
		tc:RegisterEffect(e1,true)	
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e3:SetCode(EVENT_LEAVE_FIELD)
		e3:SetReset(RESET_EVENT+0x1020000)
		e3:SetCondition(c200001.thcon)
		e3:SetOperation(c200001.thop)
		tc:RegisterEffect(e3)
	end
end
function c200001.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end
function c200001.filter(c)
	return c:IsCode(200201) and c:IsAbleToHand()
end
function c200001.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c200001.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c200001.filter,1-tp,LOCATION_DECK,0,1,nil) then
		local tc=Duel.GetFirstMatchingCard(c200001.filter,1-tp,LOCATION_DECK,0,nil)
		Duel.SendtoHand(tc,1-tp,REASON_EFFECT)
		Duel.ConfirmCards(tp,tc)
	end
end