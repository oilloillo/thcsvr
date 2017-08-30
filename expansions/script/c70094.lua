 
--最终一战！？
function c70094.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c70094.condition)
	e1:SetTarget(c70094.target)
	e1:SetOperation(c70094.operation)
	c:RegisterEffect(e1)
end
function c70094.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=2000
end
function c70094.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup()end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c70094.spfilter(c,e,tp)
	return c:IsSetCard(0x1149) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c70094.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local hg=Duel.GetFieldGroup(tp,0xe,0xe)
	hg:RemoveCard(tc)
	Duel.SendtoGrave(hg,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c70094.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local sc=g:GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
