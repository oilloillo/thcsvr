 
--七曜-火符「火天神印」
--require "expansions/nef/msc"
function c22191.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--d&d
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22191,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e4:SetTarget(c22191.target)
	e4:SetOperation(c22191.operation)
	c:RegisterEffect(e4)
	Msc.RegScMixEffect(c)
end
function c22191.filter(c)
	return c:IsFaceup()
end
function c22191.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22191.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22191.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.GetFlagEffect(tp,22191)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c22191.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.RegisterFlagEffect(tp,22191,RESET_PHASE+PHASE_END,0,1)
end
function c22191.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(500)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EVENT_DESTROY)
		e2:SetCountLimit(1)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetOperation(c22191.dmop)
		tc:RegisterEffect(e2)
	end
end
function c22191.dmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Damage(c:GetControler(),c:GetAttack()/2,REASON_EFFECT)
end
