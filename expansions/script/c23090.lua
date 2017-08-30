--水中的工程师✿河城荷取
function c23090.initial_effect(c)
	--spell set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23090,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c23090.stg)
	e2:SetOperation(c23090.sop)
	c:RegisterEffect(e2)
end
function c23090.filter(c)
	return c:IsSetCard(0x820) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c23090.stg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c23090.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c23090.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c23090.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,nil,g,1,0,0)
end
function c23090.sop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
    end
end
