 
--七曜-火水符「燃素之柱」
function c888167.initial_effect(c)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(888167,1))
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCost(c888167.cost)
	e4:SetTarget(c888167.target)
	e4:SetOperation(c888167.operation)
	c:RegisterEffect(e4)
end
function c888167.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1200) end
	Duel.PayLPCost(tp,1200)
end
function c888167.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c888167.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCondition(c888167.dcon)
		e1:SetOperation(c888167.dop)
		tc:RegisterEffect(e1)
	end
end
function c888167.dcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==tp and (c==Duel.GetAttacker() or c==Duel.GetAttackTarget())
end
function c888167.dop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
