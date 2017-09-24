--紫阳花与落雨的连结✿多多良小伞
function c26501.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c26501.matfilter,1)
	c:EnableReviveLimit()
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c26501.tgcon)
	e4:SetValue(aux.imval1)
	c:RegisterEffect(e4)
	--special set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26501,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c26501.target)
	e2:SetOperation(c26501.operation)
	--c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26501,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c26501.sptg)
	e3:SetOperation(c26501.spop)
	c:RegisterEffect(e3)
end
function c26501.matfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and (c:IsLevelBelow(3) or c:IsRankBelow(3))
end
function c26501.filter(c)
	return c:IsFacedown()
end
function c26501.tgcon(e)
	return e:GetHandler():GetLinkedGroup():FilterCount(c26501.filter,nil)>0
end
function c26501.ffilter(c,e)
	return c:IsType(TYPE_FLIP) and c:IsMSetable(true,e)
end
function c26501.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c26501.ffilter,tp,LOCATION_HAND,0,1,nil,e) end
end
function c26501.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c26501.ffilter,tp,LOCATION_HAND,0,1,1,nil,e)
	if g:GetCount()>0 then
		Duel.MSet(tp,g:GetFirst(),true,e)
	end
end
function c26501.spfilter(c,e,tp)
	return c:IsSetCard(0x208) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) and c:IsAttribute(ATTRIBUTE_WATER) and bit.band(c:GetType(),0x81)==0x81
end
function c26501.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		return Duel.IsExistingMatchingCard(c26501.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c26501.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c26501.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
