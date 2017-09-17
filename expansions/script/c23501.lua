--现世与信仰的连结✿东风谷早苗
function c23501.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c23501.matfilter,2,2)
	c:EnableReviveLimit()
	--adc
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23501,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c23501.addct)
	e1:SetOperation(c23501.addc)
	c:RegisterEffect(e1)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c23501.reptg)
	e4:SetValue(c23501.repval)
	e4:SetOperation(c23501.repop)
	c:RegisterEffect(e4)
end
function c23501.matfilter(c)
	return not c:IsLinkType(TYPE_TOKEN)
end
function c23501.xfilter(c)
	return c:IsFaceup()
end
function c23501.addct(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c23501.xfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c23501.xfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SelectTarget(tp,c23501.xfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function c23501.addc(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x128a,2)
	end
end
function c23501.repfilter(c,tp,hc)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:GetReasonPlayer()==1-tp and hc:GetLinkedGroup():IsContains(c)
end
function c23501.rdfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToGrave()
end
function c23501.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(rdfilter,tp,LOCATION_DECK,0,1,nil) and eg:IsExists(c23501.repfilter,1,nil,tp,e:GetHandler()) end
	return Duel.SelectYesNo(tp,aux.Stringid(23501,1))
end
function c23501.repval(e,c)
	return c23501.repfilter(c,e:GetHandlerPlayer(),e:GetHandler())
end
function c23501.repop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.SelectMatchingCard(tp,c23501.rdfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
