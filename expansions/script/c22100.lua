 
--红魔馆
function c22100.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--tuner
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22100,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c22100.target)
	e2:SetOperation(c22100.operation)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(22100,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c22100.cost2)
	e3:SetTarget(c22100.tg2)
	e3:SetOperation(c22100.op2)
	c:RegisterEffect(e3)
end
function c22100.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x813) and not c:IsType(TYPE_TUNER)
end
function c22100.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c22100.filter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(22100)==0 and Duel.IsExistingTarget(c22100.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c22100.filter,tp,LOCATION_MZONE,0,1,1,nil)
	e:GetHandler():RegisterFlagEffect(22100,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c22100.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
	end
end
function c22100.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c22100.filter2(c,e,tp)
	return c:IsSetCard(0xa999) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22100.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(22100)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0	and Duel.IsExistingMatchingCard(c22100.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
	e:GetHandler():RegisterFlagEffect(22100,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c22100.op2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22100.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
