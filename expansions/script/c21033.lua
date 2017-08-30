 
--正直者之死
function c21033.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetTarget(c21033.target)
	e1:SetOperation(c21033.activate)
	c:RegisterEffect(e1)
end
function c21033.costfilter(c)
	return c:GetControler()~=c:GetOwner() and c:IsSetCard(0x208)
end
function c21033.filter(c,e,tp)
	return (c:IsCode(21024) or c:IsCode(20061)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21033.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.CheckReleaseGroup(1-tp,c21033.costfilter,1,nil)
		and Duel.IsExistingMatchingCard(c21033.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c21033.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectReleaseGroup(1-tp,c21033.costfilter,1,1,nil)
	if Duel.Release(g,REASON_EFFECT)==0 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c21033.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
