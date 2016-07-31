 
--GreenHeart
function c70021.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2,c70021.ovfilter,aux.Stringid(70021,0))
	c:EnableReviveLimit()
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c70021.destg)
	e1:SetValue(c70021.value)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(70021,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c70021.cost)
	e2:SetTarget(c70021.target)
	e2:SetOperation(c70021.operation)
	c:RegisterEffect(e2)
end
function c70021.ovfilter(c)
	return c:IsFaceup() and c:IsCode(70019) and bit.band(c:GetSummonType(),SUMMON_TYPE_NORMAL)==SUMMON_TYPE_NORMAL
end
function c70021.dfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x149) and not c:IsReason(REASON_REPLACE) and c:IsControler(tp)
end
function c70021.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not eg:IsContains(e:GetHandler())
		and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and eg:IsExists(c70021.dfilter,1,nil,tp) end
	if Duel.SelectYesNo(tp,aux.Stringid(70021,1)) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end
function c70021.value(e,c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x149) and not c:IsReason(REASON_REPLACE) and c:IsControler(e:GetHandlerPlayer())
end
function c70021.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x149) and c:GetDefence()>=1000
end
function c70021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) and Duel.IsExistingMatchingCard(c70021.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	g=Duel.SelectMatchingCard(tp,c70021.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	tc=g:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENCE)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetValue(-1000)
	tc:RegisterEffect(e1)
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c70021.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToChangeControler() and not c:IsType(TYPE_TOKEN)
end
function c70021.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c70021.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c70021.filter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,c70021.filter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
end
function c70021.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
			local mg=tc:GetOverlayGroup()
			if mg:GetCount()>0 then
				Duel.SendtoGrave(mg,REASON_RULE)
			end
			tc:CancelToGrave()
			Duel.Overlay(e:GetHandler(),tc)
		end
end
