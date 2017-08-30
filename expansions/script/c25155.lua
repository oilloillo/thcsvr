--阳炎之先，骄阳之下
function c25155.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c25155.condition)
	e1:SetCost(c25155.cost)
	e1:SetTarget(c25155.target)
	e1:SetOperation(c25155.activate)
	c:RegisterEffect(e1)
end
function c25155.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c25155.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c25155.filter(c,e,tp,lr)
	return c:IsSetCard(0x208) and c:IsRace(RACE_PLANT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLevel()<=lr
end
function c25155.filter1(c)
	return c:GetLevel()
end
function c25155.filter2(c)
	return c:GetRank()
end
function c25155.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local lr=0
	if g:GetCount()>0 then lr=g:GetSum(c25155.filter1)+g:GetSum(c25155.filter2) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c25155.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,lr) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c25155.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local lr=0
	if g:GetCount()>0 then lr=g:GetSum(c25155.filter1)+g:GetSum(c25155.filter2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c25155.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,lr)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
