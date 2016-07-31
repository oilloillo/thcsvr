 
--时符·穿隧效应
function c22115.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetCost(c22115.cost)
	e1:SetTarget(c22115.target)
	e1:SetOperation(c22115.activate)
	c:RegisterEffect(e1)
end
c22115.list={[22001]=22035,[20026]=20044}
function c22115.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c22115.filter1(c,e,tp)
	local code=c:GetCode()
	local tcode=c22115.list[code]
	return tcode and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c22115.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,tcode,e,tp)
end
function c22115.filter2(c,tcode,e,tp)
	return c:IsCode(tcode) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c22115.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.CheckReleaseGroup(tp,c22115.filter1,1,nil,e,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,c22115.filter1,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetCode())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c22115.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=e:GetLabel()
	local tcode=c22115.list[code]
	local tc=Duel.GetFirstMatchingCard(c22115.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,nil,tcode,e,tp)
	if tc and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP_ATTACK) then
		tc:CompleteProcedure()
	end
end