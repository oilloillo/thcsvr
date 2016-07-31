--准备『呼唤神风的星之仪式』
function c23204.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23204,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c23204.spcost)
	e1:SetTarget(c23204.sptg)
	e1:SetOperation(c23204.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23204,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c23204.cost)
	e2:SetTarget(c23204.target)
	e2:SetOperation(c23204.activate)
	c:RegisterEffect(e2)
end
function c23204.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x28a,6,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x28a,6,REASON_COST)
end
function c23204.filter(c,e,tp)
	return c:IsSetCard(0x497) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c23204.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c23204.filter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_HAND)
end
function c23204.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c23204.filter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c23204.cfilter(c)
	return c:IsSetCard(0x497) and c:IsAbleToDeckAsCost() and c:GetCounter(0x28a)>0
end
function c23204.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
			return Duel.IsExistingMatchingCard(c23204.cfilter,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c23204.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
			e:SetLabel(g:GetFirst():GetCounter(0x28a))
		Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function c23204.spfilter(c,e,tp)
	return c:IsSetCard(0x499) and (bit.band(c:GetType(),0x41)==0x41 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,false)
	or (bit.band(c:GetType(),0x81)==0x81 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)))
end
function c23204.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c23204.spfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_MZONE)
end
function c23204.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c23204.spfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc then
		if bit.band(tc:GetType(),0x81)==0x81 then
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
			tc:CompleteProcedure()
		else
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,true,false,POS_FACEUP)
			tc:CompleteProcedure()
		end
		if e:GetLabel()>0 then
			tc:AddCounter(0x28a,e:GetLabel())
		end
	end
end
