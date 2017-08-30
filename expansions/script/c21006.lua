 
--知识与历史的半兽
function c21006.initial_effect(c)
	aux.EnableDualAttribute(c)
	--lv up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(2)
	e1:SetCondition(aux.IsDualState)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21006,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(aux.IsDualState)
	e2:SetCost(c21006.cost)
	e2:SetTarget(c21006.sptg)
	e2:SetOperation(c21006.spop)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(700)
	e3:SetCondition(aux.IsDualState)
	c:RegisterEffect(e3)	
end
function c21006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,21006)==0 end
	Duel.RegisterFlagEffect(tp,21006,RESET_PHASE+PHASE_END,0,1)
end
function c21006.filter(c,e,tp)
	return c:GetLevel()==2 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x208)
end
function c21006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c21006.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c21006.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c21006.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
