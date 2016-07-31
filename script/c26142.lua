--魔法『紫云之兆』
--require "expansions/nef/nef"
function c26142.initial_effect(c)
	Nef.AddRitualProcEqual(c,c26142.ritual_filter,aux.Stringid(26142,0))
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26142,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26142.target)
	e1:SetOperation(c26142.activate)
	c:RegisterEffect(e1)
end
function c26142.ritual_filter(c)
	return c:IsCode(26122) and bit.band(c:GetType(),0x81)==0x81
end
function c26142.cfilter(c)
	return (c:IsSetCard(0x251) or c:IsSetCard(0x252)) and c:IsType(TYPE_SPELL) and c:IsAbleToRemove()
end
function c26142.filter(c,e,tp)
	return c:IsCode(26122) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
		and bit.band(c:GetType(),0x81)==0x81 and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c26142.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c26142.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,e:GetHandler())
			and Duel.IsExistingMatchingCard(c26142.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c26142.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0
		or not Duel.IsExistingMatchingCard(c26142.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,e:GetHandler()) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c26142.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if tg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c26142.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,2,e:GetHandler())
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		local tc=tg:GetFirst()
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
