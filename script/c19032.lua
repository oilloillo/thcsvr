--午夜已到
function c19032.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,19032+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c19032.target)
	e1:SetOperation(c19032.activate)
	c:RegisterEffect(e1)
	--fuckon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(19030,0))
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_GRAVE)
	--e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1,19032)
	e4:SetCondition(c19032.condition)
	e4:SetTarget(c19032.futg)
	e4:SetOperation(c19032.fuop)
	c:RegisterEffect(e4)
end
function c19032.mfilter(c)
	return c:IsSetCard(0x273) or (c:IsSetCard(0x3208) and c:GetAttack()<=2000)
end
function c19032.filter(c,e,tp)
	return c:IsCode(19030) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function c19032.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 and not Duel.IsExistingMatchingCard(c19032.mfilter,tp,LOCATION_MZONE,0,1,nil) then
			return false
		else return
			Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.IsExistingMatchingCard(c19032.mfilter,tp,0x6,0,1,nil)
			and Duel.IsExistingMatchingCard(c19032.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0x6)
end
function c19032.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 and not Duel.IsExistingMatchingCard(c19032.mfilter,tp,LOCATION_MZONE,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local mg=Duel.SelectMatchingCard(tp,c19032.mfilter,tp,0x6,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c19032.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if mg:GetCount()==0 or not tc then return end
	Duel.SendtoGrave(mg,REASON_EFFECT)
	tc:SetMaterial(mg)
	Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
end
function c19032.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end
function c19032.rmfilter1(c)
	return c:IsSetCard(0x273) and c:IsAbleToRemove()
end
function c19032.rmfilter2(c)
	return c:IsSetCard(0x3208) and c:IsAbleToRemove()
end
function c19032.futg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c19032.rmfilter1,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c19032.rmfilter2,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c19032.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,tp,LOCATION_GRAVE)
end
function c19032.fuop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local mg=Duel.SelectMatchingCard(tp,c19032.rmfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	local mg2=Duel.SelectMatchingCard(tp,c19032.rmfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	mg:Merge(mg2)
	mg:AddCard(e:GetHandler())
	if mg:GetCount()<3 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c19032.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.Remove(mg,POS_FACEUP,REASON_EFFECT)
	Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
end
