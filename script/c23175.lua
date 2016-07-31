--守矢神社
function c23175.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c23175.activate)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetOperation(c23175.ctop)
	c:RegisterEffect(e2)
	--adc
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(23175,0))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c23175.addct)
	e3:SetOperation(c23175.addc)
	c:RegisterEffect(e3)
end
function c23175.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	e:GetHandler():AddCounter(0x28a,1)
		if Duel.GetFlagEffect(tp,23200)==0 then
			Duel.RegisterFlagEffect(tp,23200,0,0,0)
		end
end
function c23175.ctop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:GetCount()*2
	if ct>5 then ct=5 end
	e:GetHandler():AddCounter(0x28a,ct)
		if Duel.GetFlagEffect(tp,23200)==0 then
			Duel.RegisterFlagEffect(tp,23200,0,0,0)
		end
end
function c23175.xfilter(c)
	return c:IsSetCard(0x497) and c:IsFaceup()
end
function c23175.addct(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c23175.xfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c23175.xfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.SelectTarget(tp,c23175.xfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c23175.addc(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local ct=tc:GetLevel()+1
		tc:AddCounter(0x28a,ct)
		local cp=tc:GetControler()
		if Duel.GetFlagEffect(cp,23200)==0 then
			Duel.RegisterFlagEffect(cp,23200,0,0,0)
		end
	end
end
