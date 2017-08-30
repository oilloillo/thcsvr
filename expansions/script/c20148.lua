 
--上海人形③✿
function c20148.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20148,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c20148.spcost)
	e1:SetTarget(c20148.sptg)
	e1:SetOperation(c20148.spop)
	c:RegisterEffect(e1)
end
function c20148.refilter(c)
	return c:IsSetCard(0x186) and c:IsRace(RACE_MACHINE)
end
function c20148.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,20148)==0 and e:GetHandler():IsReleasable()
		and Duel.CheckReleaseGroup(tp,c20148.refilter,1,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,c20148.refilter,1,1,e:GetHandler())
	Duel.Release(e:GetHandler(),REASON_COST)
	Duel.Release(g,REASON_COST)
	Duel.RegisterFlagEffect(tp,20148,RESET_PHASE+PHASE_END,0,1)
end
function c20148.filter1(c,e,tp)
	return c:IsSetCard(0x186) and c:GetLevel()==2 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20148.filter2(c,e,tp)
	return c:IsSetCard(0x186) and c:GetLevel()==1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20148.filter(c,e,tp)
	return c:IsSetCard(0x186) and c:IsLevelBelow(2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20148.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroupCount(c20148.filter1,tp,LOCATION_DECK,0,nil,e,tp)
	local g2=Duel.GetMatchingGroupCount(c20148.filter2,tp,LOCATION_DECK,0,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and (g1>0 or g2>1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c20148.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g2=Duel.GetMatchingGroupCount(c20148.filter2,tp,LOCATION_DECK,0,nil,e,tp)
	local g=Group.CreateGroup()
	local lv=2
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if g2<2 then
		g=Duel.SelectMatchingCard(tp,c20148.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	else
		g=Duel.SelectMatchingCard(tp,c20148.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	end
	if g:GetCount()>0 then
		if lv-g:GetFirst():GetLevel()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g2=Duel.SelectMatchingCard(tp,c20148.filter2,tp,LOCATION_DECK,0,1,1,g:GetFirst(),e,tp)
			if g2:GetCount()>0 then
				g:Merge(g2)
			end
		end
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
