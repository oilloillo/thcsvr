 
--柊去椿来
function c20168.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c20168.cost)
	e1:SetTarget(c20168.target)
	e1:SetOperation(c20168.activate)
	c:RegisterEffect(e1)
end
function c20168.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.CheckReleaseGroup(tp,aux.TRUE,1,nil) and g:GetCount()==1 end
	Duel.Release(g:GetFirst(),REASON_COST)
end
function c20168.filter(c,e,tp)
	return (c:IsCode(20013) or c:IsCode(20016) or c:IsSetCard(0x123)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20168.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c20168.filter,tp,0x51,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0x51)
end
function c20168.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c20168.filter,tp,0x51,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.BreakEffect()
	local ct=Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_HAND+LOCATION_GRAVE,nil)
	Duel.Recover(tp,ct*200,REASON_EFFECT)
end
