 
--文乐「人形思想」
function c20156.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c20156.target)
	e1:SetOperation(c20156.activate)
	c:RegisterEffect(e1)
end
function c20156.tfilter(c,atk,def,e,tp)
	return c:IsSetCard(0x186) and c:GetAttack()==atk and c:GetDefence()==def and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20156.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x186)
		and Duel.IsExistingMatchingCard(c20156.tfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c:GetAttack()-100,c:GetDefence()-100,e,tp)
end
function c20156.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c20156.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c20156.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c20156.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c20156.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c20156.tfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc:GetAttack()-100,tc:GetDefence()-100,e,tp)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
