 
--废狱「对谦虚的富者之记恨」
function c24041.initial_effect(c)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c24041.condition)
	e2:SetTarget(c24041.target)
	e2:SetOperation(c24041.activate)
	c:RegisterEffect(e2)
end
function c24041.cfilter(c)
	return c:IsFaceup() and (c:IsCode(24007) or c:IsCode(24010))
end
function c24041.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c24041.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c24041.filter(c,e,tp)
	return c:IsCode(24007) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c24041.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c24041.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_HAND)
end
function c24041.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c24041.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local dg=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	if dg:GetCount()==0 then return end
	local sg=dg:RandomSelect(1-tp,1)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
