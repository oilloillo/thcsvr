 
--夜雀老板娘的烧烤店
function c21047.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c21047.recop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(21047,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c21047.condition)
	e4:SetCost(c21047.cost)
	e4:SetTarget(c21047.target)
	e4:SetOperation(c21047.operation)
	--c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(21047,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c21047.condition2)
	e5:SetCost(c21047.cost)
	e5:SetTarget(c21047.target2)
	e5:SetOperation(c21047.operation2)
	c:RegisterEffect(e5)
end
function c21047.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,300,REASON_EFFECT)
end
function c21047.cfilter(c)
	return c:IsFaceup() and c:IsCode(21003)
end
function c21047.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c21047.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c21047.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c21047.filter(c,e,tp)
	return c:IsSetCard(0x208) and c:IsLevelBelow(7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21047.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c21047.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c21047.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c21047.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c21047.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)>=9000
end
function c21047.filter2(c,e,tp)
	return c:IsSetCard(0x208) and c:IsLevelBelow(2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21047.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c21047.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c21047.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c21047.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
