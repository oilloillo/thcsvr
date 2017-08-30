--甘兔庵-桐间纱路
function c401405.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(401405,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c401405.drcon)
	e1:SetTarget(c401405.drtg)
	e1:SetOperation(c401405.drop)
	c:RegisterEffect(e1)
	--nontuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e2)
end
function c401405.filter(c,e,tp)
	return c:IsSetCard(0x404) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(421405) and not c:IsCode(401405)
end
function c401405.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c401405.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_HAND) and chkc:IsControler(tp) and c401405.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c401405.filter,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c401405.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c401405.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
	Duel.SpecialSummonComplete()

	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
end
end
