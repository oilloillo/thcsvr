 
--七曜-火土符「环状熔岩带」
function c888168.initial_effect(c)
	--d&d
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(888168,1))
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c888168.target)
	e4:SetOperation(c888168.operation)
	c:RegisterEffect(e4)
end
function c888168.filter(c)
	return c:IsFaceup()
end
function c888168.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c888168.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c888168.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c888168.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c888168.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENCE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(800)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetOperation(c888168.dmop1)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EVENT_BE_BATTLE_TARGET)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetOperation(c888168.dmop2)
		tc:RegisterEffect(e3)
	end
end
function c888168.dmop1(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if g and g:IsContains(e:GetHandler()) then
		Duel.Damage(1-tp,2500,REASON_EFFECT)
	end
end
function c888168.dmop2(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then return end
	Duel.Damage(1-tp,3000,REASON_EFFECT)
end
