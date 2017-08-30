 
--七曜-火符「火神的光辉」
function c888151.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--damage up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetCondition(c888151.rdcon)
	e4:SetOperation(c888151.rdop)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(888151,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c888151.destg)
	e5:SetOperation(c888151.desop)
	c:RegisterEffect(e5)
end
function c888151.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetFlagEffect(tp,8881510)~=0
end
function c888151.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,1000,REASON_BATTLE)
end
function c888151.filter(c)
	return c:IsDestructable()
end
function c888151.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c888151.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c888151.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c888151.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c888151.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
	Duel.RegisterFlagEffect(tp,8881510,RESET_PHASE+PHASE_END,0,1)
end
