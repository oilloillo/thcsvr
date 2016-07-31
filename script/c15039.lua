 
--最后的审判
function c15039.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c15039.condition)
	e1:SetTarget(c15039.target)
	e1:SetOperation(c15039.activate)
	c:RegisterEffect(e1)
end
function c15039.spfilter(c)
	return c:IsSetCard(0x150) and c:IsType(TYPE_MONSTER)
end
function c15039.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c15039.spfilter,tp,LOCATION_GRAVE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>4
end
function c15039.filter(c,e,tp)
	return c:IsCode(15016) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c15039.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c15039.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c15039.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c15039.desfilter,tp,0,0xe,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c15039.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c15039.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
	local sg=Duel.GetMatchingGroup(c15039.desfilter,tp,0,0xe,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
		local conf=Duel.GetFieldGroup(tp,0,0xe)
		if conf:GetCount()>0 then
			Duel.ConfirmCards(tp,conf)
			Duel.ShuffleHand(1-tp)
		end
	end
end
