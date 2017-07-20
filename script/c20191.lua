--天上剑『天人之五衰』
function c20191.initial_effect(c)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c20191.dtg)
	e2:SetOperation(c20191.dop)
	c:RegisterEffect(e2)
end
function c20191.dfilter(c)
	return c:IsFaceup() and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
		and (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_WIND) or c:IsAttribute(ATTRIBUTE_EARTH))
end
function c20191.dtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c20191.dfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20191.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c20191.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,0,1,0,0)
end
function c20191.filter(c,code)
	return c:IsAbleToHand() and c:GetCode()==code
end
function c20191.dop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local code=tc:GetCode()
		if Duel.IsExistingMatchingCard(c20191.filter,tp,LOCATION_DECK,0,1,e:GetHandler(),code)
			and Duel.SelectYesNo(tp,aux.Stringid(20191,0)) then
			cg=Duel.SelectMatchingCard(tp,c20191.filter,tp,LOCATION_DECK,0,1,1,nil,code)
			Duel.SendtoHand(cg,nil,REASON_EFFECT)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetRange(0xc)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetOperation(c20191.desop)
		tc:RegisterEffect(e1)
	end
end
function c20191.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
