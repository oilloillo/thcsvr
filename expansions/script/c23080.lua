--厄符『厄运』
function c23080.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c23080.target)
	e1:SetOperation(c23080.activate)
	c:RegisterEffect(e1)
end
function c23080.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x113) 
end
function c23080.filter(c)
	return c:IsFaceup()
end
function c23080.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c23080.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c23080.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_EXTRA,0,nil)<=10 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c23080.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c23080.chfilter(c,e)
	return c:IsFaceup() and c:IsRelateToEffect(e)
end
function c23080.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(c23080.chfilter,nil,e)
	if tg:GetCount()>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tg:GetFirst():RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetOperation(c23080.desop)
		tg:GetFirst():RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tg:GetFirst():RegisterEffect(e3)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		tg:GetFirst():RegisterEffect(e4)
	end
end
function c23080.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
