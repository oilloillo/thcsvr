 
--蓬莱人形③✿
function c20149.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20149,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c20149.spcost)
	e1:SetTarget(c20149.sptg)
	e1:SetOperation(c20149.spop)
	c:RegisterEffect(e1)
end
function c20149.refilter(c)
	return c:IsSetCard(0x186) and c:IsRace(RACE_MACHINE)
end
function c20149.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,20149)==0 and e:GetHandler():IsReleasable()
		and Duel.CheckReleaseGroup(tp,c20149.refilter,1,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,c20149.refilter,1,1,e:GetHandler())
	Duel.Release(e:GetHandler(),REASON_COST)
	Duel.Release(g,REASON_COST)
	Duel.RegisterFlagEffect(tp,20149,RESET_PHASE+PHASE_END,0,1)
end
function c20149.filter(c,e,tp)
	return c:IsSetCard(0x186) and c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20149.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c20149.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c20149.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c20149.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
