 
--七曜-木符「风灵角笛上级」
function c22138.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c22138.con)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22138,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(c22138.acttg)
	e2:SetOperation(c22138.actop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_DECK)
	e3:SetCondition(c22138.actcon)
	c:RegisterEffect(e3)
	--indestructable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e4:SetCountLimit(1)
	e4:SetValue(c22138.valcon)
	c:RegisterEffect(e4)
	--spell set
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22138,1))
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(c22138.stg)
	e5:SetOperation(c22138.sop)
	c:RegisterEffect(e5)
end
function c22138.con(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():GetFlagEffect(22138)==1
end
function c22138.actfilter(c)
	return c:IsSetCard(0x180) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsFaceup()
end
function c22138.exfilter(c)
	return c:IsCode(22200) and c:GetFlagEffect(2220000)>0
end
function c22138.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22138.actfilter,tp,LOCATION_SZONE,0,2,nil) or
		(Duel.IsExistingMatchingCard(c22138.exfilter,tp,LOCATION_SZONE,0,1,nil) and Duel.IsExistingMatchingCard(c22138.actfilter,tp,LOCATION_SZONE,0,1,nil)) end
	e:GetHandler():RegisterFlagEffect(22138,RESET_EVENT+0x1fe0000,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c22138.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ct=0
	if Duel.IsExistingMatchingCard(c22138.exfilter,tp,LOCATION_SZONE,0,1,nil) 
		then ct=1
	else ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22138.actfilter,tp,LOCATION_SZONE,0,ct,ct,nil)
		if Duel.SendtoGrave(g,REASON_MATERIAL)~=0 then
			if not e:GetHandler():GetActivateEffect():IsActivatable(tp) then return end
			Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	Duel.RaiseEvent(e:GetHandler(),EVENT_CHAIN_SOLVED,e:GetHandler():GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
end
function c22138.dactfilter(c)
	return c:IsFaceup() and c:IsCode(22017)
end
function c22138.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22138.dactfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22138.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c22138.filter(c)
	return c:IsSetCard(0x177) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c22138.stg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c22138.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c22138.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c22138.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,nil,g,1,0,0)
end
function c22138.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
    end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
end
