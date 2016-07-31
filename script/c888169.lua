 
--七曜-火金符「圣爱尔摩火柱」
function c888169.initial_effect(c)
	--d&d
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(888169,1))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c888169.target)
	e4:SetOperation(c888169.operation)
	c:RegisterEffect(e4)
end
function c888169.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c888169.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c888169.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c888169.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c888169.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local dc=tc:GetDefence()
	if dc>1500 then dc=1500 end
	if dc<1000 then dc=1000 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dc)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dc)
end
function c888169.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local dc=tc:GetDefence()
	if dc>1500 then dc=1500 end
	if dc<1000 then dc=1000 end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(dc)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Damage(p,dc,REASON_EFFECT)
	end
end
