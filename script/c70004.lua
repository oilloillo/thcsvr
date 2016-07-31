 
--PurpleHeart
function c70004.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2,c70004.ovfilter,aux.Stringid(70004,0))
	c:EnableReviveLimit()
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c70004.destg)
	e1:SetValue(c70004.value)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(70004,2))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c70004.cost)
	e2:SetTarget(c70004.target)
	e2:SetOperation(c70004.operation)
	c:RegisterEffect(e2)
end
function c70004.ovfilter(c)
	return c:IsFaceup() and c:IsCode(70001) and bit.band(c:GetSummonType(),SUMMON_TYPE_NORMAL)==SUMMON_TYPE_NORMAL
end
function c70004.dfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x149) and not c:IsReason(REASON_REPLACE) and c:IsControler(tp)
end
function c70004.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not eg:IsContains(e:GetHandler())
		and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and eg:IsExists(c70004.dfilter,1,nil,tp) end
	if Duel.SelectYesNo(tp,aux.Stringid(70004,1)) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end
function c70004.value(e,c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x149) and not c:IsReason(REASON_REPLACE) and c:IsControler(e:GetHandlerPlayer())
end
function c70004.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x149) and c:GetDefence()>=2000
end
function c70004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,70004)==0 and Duel.IsExistingMatchingCard(c70004.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	g=Duel.SelectMatchingCard(tp,c70004.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	tc=g:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENCE)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetValue(-2000)
	tc:RegisterEffect(e1)
	Duel.RegisterFlagEffect(tp,70004,RESET_PHASE+PHASE_END,0,1)
end
function c70004.filter(c)
	return c:IsSetCard(0x149) and c:IsAbleToHand() and c:IsLevelAbove(1)
end
function c70004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c70004.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c70004.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c70004.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c70004.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		if tc:IsSummonable(true,nil) then
			Duel.Summon(tp,tc,true,nil)
		end
	end
end
