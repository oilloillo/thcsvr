 
--Grimoire of Alice
function c15050.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCondition(c15050.condition)
	e1:SetTarget(c15050.target)
	e1:SetOperation(c15050.activate)
	c:RegisterEffect(e1)
end
function c15050.afilter(c)
	return not c:IsSetCard(0x208) and c:IsType(TYPE_MONSTER)
end
function c15050.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c15050.afilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil)
end
function c15050.filter(c,e,tp,m)
	local cd=c:GetCode()
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsCode(15024) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) then return false end
	if m:IsContains(c) then
		m:RemoveCard(c)
		result=m:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
		m:AddCard(c)
	else
		result=m:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
	end
	return result
end
function c15050.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		return Duel.IsExistingMatchingCard(c15050.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetChainLimit(aux.FALSE)
end
function c15050.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c15050.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		mg:RemoveCard(tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
	local g=Duel.GetMatchingGroup(c15050.atkfilter,tp,LOCATION_MZONE,0,nil)
	local c=e:GetHandler()
	local ac=g:GetFirst()
	while ac do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(3000)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		ac:RegisterEffect(e1)
		ac=g:GetNext()
	end
end
function c15050.atkfilter(c)
	return c:IsFaceup() and (c:IsCode(15007) or c:IsCode(20007) or c:IsCode(20061) or c:IsCode(15024))
end
