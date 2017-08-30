--独臂有角的仙人✿茨木华扇
function c210001.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(210001,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c210001.sptg)
	e1:SetOperation(c210001.spop)
	c:RegisterEffect(e1)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c210001.tgcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)--[[
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetValue(c210001.tgvalue)
	c:RegisterEffect(e5)]]
end
function c210001.filter(c,e,tp)
	return c:IsSetCard(0x1710) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c210001.filter2(c)
	return c:IsLocation(LOCATION_HAND) or (c:IsLocation(LOCATION_ONFIELD) and c:IsType(TYPE_SPELL) and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0  and c:IsFaceup())
end
function c210001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c210001.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(c210001.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c210001.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	if not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c210001.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(c210001.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sc=Duel.SelectMatchingCard(tp,c210001.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,e,tp):GetFirst()
	Duel.SendtoGrave(sc,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c210001.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end
function c210001.tgfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x1710) or c:IsSetCard(0x2710))
end
function c210001.tgcon(e)
	return Duel.IsExistingMatchingCard(c210001.tgfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end--[[
function c210001.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end]]