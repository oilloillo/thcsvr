--备用弹夹
function c64010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(64010,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c64010.mattg)
	e2:SetOperation(c64010.matop)
	c:RegisterEffect(e2)
	--material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(64010,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c64010.target)
	e3:SetOperation(c64010.operation)
	c:RegisterEffect(e3)
end
function c64010.xyzfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x280)
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,c)
end
function c64010.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c64010.xyzfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c64010.xyzfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c64010.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c64010.matop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,tc)
		if g:GetCount()>0 then
			local mg=g:GetFirst():GetOverlayGroup()
			if mg:GetCount()>0 then
				Duel.SendtoGrave(mg,REASON_RULE)
			end
			Duel.Overlay(tc,g)
		end
	end
end
function c64010.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x280)
end
function c64010.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c64010.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c64010.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c64010.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c64010.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
