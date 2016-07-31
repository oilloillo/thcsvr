 
--永夜返 -子之刻-
function c21105.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c21105.cost)
	e1:SetOperation(c21105.activate)
	c:RegisterEffect(e1)
	--effect indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c21105.condition)
	e2:SetTarget(c21105.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c21105.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,21105)==0 end
	Duel.RegisterFlagEffect(tp,21105,RESET_PHASE+PHASE_END,0,1)
end
function c21105.filter(c,e,tp)
	return c:IsLevelBelow(2) and c:IsSetCard(0x256) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21105.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c21105.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(21105,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		local tc=sg:GetFirst()
		if tc then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
		end
	end
end
function c21105.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c21105.indtg(e,c)
	return c:IsSetCard(0x161) or c:IsSetCard(0x256)
end
