--秋符『秋季的狂风』
function c999310.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,999310+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c999310.cost)
	e1:SetTarget(c999310.target)
	e1:SetOperation(c999310.operation)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(999310,ACTIVITY_SPSUMMON,c999310.counterfilter)
end

function c999310.counterfilter(c)
	return c:IsRace(RACE_PLANT)
end

function c999310.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsRace(0xffffff-RACE_PLANT)
end

function c999310.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local aspc = Duel.GetCustomActivityCount(999310,tp,ACTIVITY_SPSUMMON)
	if chk==0 then return aspc==nil or aspc==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c999310.sumlimit)
	Duel.RegisterEffect(e1,tp)
end

function c999310.spfilter1(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsRace(RACE_PLANT) and c:GetLevel()==2 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c999310.spfilter2(c,e,tp)
	return not c:IsType(TYPE_TUNER) and c:IsRace(RACE_PLANT) and c:GetLevel()==2 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c999310.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingTarget(c999310.spfilter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.IsExistingTarget(c999310.spfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end

function c999310.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c999310.spfilter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local g2=Duel.SelectMatchingCard(tp,c999310.spfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		g1:Merge(g2)
		if Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP) == 2 then
			local tc = g1:GetFirst()
			while tc do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e2)
				tc = g1:GetNext()
			end
			--
			local sg=Duel.GetMatchingGroup(c999310.extrafilter,tp,LOCATION_EXTRA,0,nil,g1,e,tp)
			if not sg or sg:GetCount()==0 then 
				Duel.BreakEffect()
				Duel.SendtoGrave(g1,REASON_EFFECT)
				return 
			end
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=sg:Select(tp,1,1,nil):GetFirst()
			if tc:IsType(TYPE_XYZ) then
				Duel.XyzSummon(tp,tc,g1)
			elseif tc:IsType(TYPE_SYNCHRO) then
				Duel.SynchroSummon(tp,tc,nil,g1)
			elseif tc:IsType(TYPE_FUSION) then
				Duel.SendtoGrave(g1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end

function c999310.extrafilter(c,mg,e,tp)
	if not c:IsRace(RACE_PLANT) then return false end
	if c:IsType(TYPE_SYNCHRO) then
		return c:IsSynchroSummonable(nil,mg)
	elseif c:IsType(TYPE_XYZ) then
		return c.xyz_count==2 and c:IsXyzSummonable(mg)
	elseif c:IsType(TYPE_FUSION) then
		return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(mg)
	end
	return false
end