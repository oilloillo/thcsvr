--准备『召请建御名方神』
function c23205.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c23205.cost)
	e1:SetTarget(c23205.target)
	e1:SetOperation(c23205.activate)
	c:RegisterEffect(e1)
end
function c23205.cfilter(c)
	return c:GetCounter(0x28a)>8 and c:IsAbleToDeckAsCost()
end
function c23205.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23205.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c23205.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	e:SetLabel(g:GetFirst():GetCounter(0x28a))
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function c23205.filter(c,e,tp)
	return c:IsSetCard(0x498) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	or (bit.band(c:GetType(),0x81)==0x81 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)))
end
function c23205.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c23205.filter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_DECK)
end
function c23205.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c23205.filter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc then
		if bit.band(tc:GetType(),0x81)==0x81 then
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
			tc:CompleteProcedure()
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
		tc:AddCounter(0x28a,e:GetLabel())
	end
end
