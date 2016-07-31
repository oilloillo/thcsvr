 
--ルウィー
function c70083.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(70083,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c70083.target)
	e2:SetOperation(c70083.operation)
	c:RegisterEffect(e2)
	--defup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_DEFENCE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x149))
	e4:SetValue(1500)
	c:RegisterEffect(e4)
end
function c70083.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x2149)
end
function c70083.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c70083.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) 
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_GRAVE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_GRAVE,1,1,e:GetHandler())
end
function c70083.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()>0 then
			Duel.SendtoGrave(mg,REASON_RULE)
		end
		if Duel.GetMatchingGroupCount(c70083.filter,tp,LOCATION_MZONE,0,nil)>0 then
			local g=Duel.SelectMatchingCard(tp,c70083.filter,tp,LOCATION_MZONE,0,1,1,nil)
			local sg=g:GetFirst()
			Duel.Overlay(sg,tc)
		end
	end
end
