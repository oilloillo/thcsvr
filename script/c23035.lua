 --妖怪之山
function c23035.initial_effect(c)
	c:EnableCounterPermit(0x28a)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCondition(c23035.ctcon)
	e2:SetOperation(c23035.ctop)
	c:RegisterEffect(e2)
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c23035.val)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetDescription(aux.Stringid(23035,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c23035.sptg)
	e4:SetOperation(c23035.spop)
	c:RegisterEffect(e4)
end
function c23035.ctfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) or c:IsPreviousLocation(LOCATION_HAND)
end
function c23035.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c23035.ctfilter,1,nil)
end
function c23035.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x28a,1)
	if Duel.GetFlagEffect(tp,23200)==0 then
		Duel.RegisterFlagEffect(tp,23200,0,0,0)
	end
end
function c23035.val(e)
	return e:GetHandler():GetCounter(0x28a)*-100
end
function c23035.spfilter(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and Duel.IsCanRemoveCounter(tp,1,0,0x28a,lv,REASON_COST) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsSetCard(0x208) and c:IsAttribute(ATTRIBUTE_WIND)
end
function c23035.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c23035.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,deck)
end
function c23035.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c23035.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local lv=g:GetFirst():GetLevel()
	if lv<2 then lv=2 end
	Duel.RemoveCounter(tp,1,0,0x28a,lv,REASON_COST)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
