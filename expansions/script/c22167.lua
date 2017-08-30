 
--七曜-火水符「燃素之柱」
function c22167.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c22167.con)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22167,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(c22167.acttg)
	e2:SetOperation(c22167.actop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_DECK)
	e3:SetCondition(c22167.actcon)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22167,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c22167.cost)
	e4:SetTarget(c22167.target)
	e4:SetOperation(c22167.operation)
	c:RegisterEffect(e4)
end
function c22167.con(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():GetFlagEffect(22167)==1
end
function c22167.actfilter1(c)
	return c:IsSetCard(0x178) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsFaceup()
end
function c22167.actfilter2(c)
	return c:IsSetCard(0x179) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsFaceup()
end
function c22167.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22167.actfilter1,tp,LOCATION_SZONE,0,1,nil) and 
		Duel.IsExistingMatchingCard(c22167.actfilter2,tp,LOCATION_SZONE,0,1,nil) end
	e:GetHandler():RegisterFlagEffect(22167,RESET_EVENT+0x1fe0000,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c22167.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c22167.actfilter1,tp,LOCATION_SZONE,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c22167.actfilter2,tp,LOCATION_SZONE,0,1,1,nil)
	g1:Merge(g2)
		if Duel.SendtoGrave(g1,REASON_MATERIAL)~=0 then
			if not e:GetHandler():GetActivateEffect():IsActivatable(tp) then return end
			Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	Duel.RaiseEvent(e:GetHandler(),EVENT_CHAIN_SOLVED,e:GetHandler():GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
end
function c22167.dactfilter(c)
	return c:IsFaceup() and c:IsCode(22017)
end
function c22167.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22167.dactfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22167.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1200) and e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	Duel.PayLPCost(tp,1200)
end
function c22167.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c22167.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCondition(c22167.dcon)
		e1:SetOperation(c22167.dop)
		tc:RegisterEffect(e1)
	end
end
function c22167.dcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==tp and (c==Duel.GetAttacker() or c==Duel.GetAttackTarget())
end
function c22167.dop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
