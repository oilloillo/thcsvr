 
--转世「一条复生桥」
function c21048.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(c21048.condition)
	e1:SetTarget(c21048.target)
	e1:SetOperation(c21048.operation)
	c:RegisterEffect(e1)
end
function c21048.cfilter(c,tp)
	return c:IsSetCard(0x208) and c:IsReason(REASON_BATTLE) and c:IsLocation(LOCATION_GRAVE) and c:GetPreviousControler()==tp
end
function c21048.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c21048.cfilter,1,nil,tp)
end
function c21048.spfilter(c,e,tp)
	return (c:IsCode(21006) or c:IsCode(21069)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21048.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c21048.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c21048.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c21048.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()~=0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local tc=g:GetFirst()
		if tc:IsFaceup() and tc:IsType(TYPE_DUAL) and not tc:IsDualState() and Duel.CheckLPCost(tp,500) and Duel.SelectYesNo(tp,aux.Stringid(21048,0)) then
			Duel.PayLPCost(tp,500)
			tc:EnableDualState()
		end
	end
end
