 
--光符「救世之光」
function c27025.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c27025.target)
	e1:SetOperation(c27025.activate)
	c:RegisterEffect(e1)
end
function c27025.mfilter1(c,e)
	return c:IsFaceup() and c:GetLevel()>0 and not c:IsImmuneToEffect(e) and c:IsReleasable()
end
function c27025.mfilter2(c)
	return c:IsHasEffect(EFFECT_EXTRA_RITUAL_MATERIAL) and c:IsAbleToRemove()
end
function c27025.get_material(e,tp)
	local g1=Duel.GetMatchingGroup(c27025.mfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	local g2=Duel.GetMatchingGroup(c27025.mfilter2,tp,LOCATION_GRAVE,0,nil)
	g1:Merge(g2)
	return g1
end
function c27025.filter(c,e,tp,m)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsSetCard(0x194)
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) then return false end
	if m:IsContains(c) then
		m:RemoveCard(c)
		result=m:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
		m:AddCard(c)
	else
		result=m:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
	end
	return result
end
function c27025.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local mg=c27025.get_material(e,tp)
		return Duel.IsExistingMatchingCard(c27025.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c27025.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=c27025.get_material(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c27025.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		mg:RemoveCard(tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(tc:GetAttack()/2)
		e1:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END)
		--tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
		tc:CompleteProcedure()
	end
end
