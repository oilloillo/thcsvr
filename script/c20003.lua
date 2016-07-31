 
--凶兆的黑猫
function c20003.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c20003.spcon)
	e1:SetTarget(c20003.sptg)
	e1:SetOperation(c20003.spop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c20003.atkcon)
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(20003,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CHAIN_UNIQUE)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCondition(c20003.condition)
	e3:SetTarget(c20003.target)
	e3:SetOperation(c20003.operation)
	c:RegisterEffect(e3)
end
function c20003.cfilter(c)
	return c:IsFaceup() and c:IsLevelBelow(2)
end
function c20003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c20003.cfilter,1,nil)
end
function c20003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c20003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c20003.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc225)
end
function c20003.atkcon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c20003.atkfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c20003.filter(c,e,tp)
	return c:IsLevelBelow(3) and c:IsSetCard(0x208) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20003.condition(e,tp,eg,ep,ev,re,r,rp)
	if(Duel.GetFlagEffect(tp,20103)==0) then Duel.RegisterFlagEffect(tp,20103,0,0,0)
		else return false end
	return Duel.GetFlagEffect(tp,20103)==1
end
function c20003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c20003.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c20003.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c20003.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
