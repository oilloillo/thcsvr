 
--七曜-火符「火神的光辉」
function c22151.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c22151.con)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22151,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(c22151.acttg)
	e2:SetOperation(c22151.actop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_DECK)
	e3:SetCondition(c22151.actcon)
	c:RegisterEffect(e3)
	--damage up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetCondition(c22151.rdcon)
	e4:SetOperation(c22151.rdop)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22151,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c22151.destg)
	e5:SetOperation(c22151.desop)
	c:RegisterEffect(e5)
end
function c22151.con(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():GetFlagEffect(22151)==1
end
function c22151.actfilter(c)
	return c:IsSetCard(0x178) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsFaceup()
end
function c22151.exfilter(c)
	return c:IsCode(22200) and c:GetFlagEffect(2220000)>0
end
function c22151.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22151.actfilter,tp,LOCATION_SZONE,0,3,nil) or
		(Duel.IsExistingMatchingCard(c22151.exfilter,tp,LOCATION_SZONE,0,1,nil) and Duel.IsExistingMatchingCard(c22151.actfilter,tp,LOCATION_SZONE,0,2,nil)) end
	e:GetHandler():RegisterFlagEffect(22151,RESET_EVENT+0x1fe0000,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c22151.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ct=0
	if Duel.IsExistingMatchingCard(c22151.exfilter,tp,LOCATION_SZONE,0,1,nil) 
		then ct=2
	else ct=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22151.actfilter,tp,LOCATION_SZONE,0,ct,ct,nil)
		if Duel.SendtoGrave(g,REASON_MATERIAL)~=0 then
			if not e:GetHandler():GetActivateEffect():IsActivatable(tp) then return end
			Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	Duel.RaiseEvent(e:GetHandler(),EVENT_CHAIN_SOLVED,e:GetHandler():GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
end
function c22151.dactfilter(c)
	return c:IsFaceup() and c:IsCode(22017)
end
function c22151.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22151.dactfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22151.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetFlagEffect(tp,221510)~=0
end
function c22151.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,1000,REASON_BATTLE)
end
function c22151.filter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c22151.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c22151.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22151.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c22151.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c22151.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
	Duel.RegisterFlagEffect(tp,221510,RESET_PHASE+PHASE_END,0,1)
end
