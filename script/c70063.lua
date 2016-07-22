--日本一
function c70063.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(70063,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c70063.spcon)
	e1:SetTarget(c70063.sptg)
	e1:SetOperation(c70063.spop)
	c:RegisterEffect(e1)
end
function c70063.cfilter(c)
	return c:IsFaceup() and (c:IsCode(70007) or c:IsCode(70036) or c:IsCode(70042) or c:IsCode(70047))
end
function c70063.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c70063.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c70063.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c70063.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetOperation(c70063.op)
		Duel.RegisterEffect(e2,tp)
	end
end
function c70063.tgfilter(c)
	return c:IsCode(70062) and c:IsAbleToGrave()
end
function c70063.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,70063)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c70063.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
