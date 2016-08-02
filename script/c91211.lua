--请问您今天要来点兔子吗?
function c91211.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c91211.condition)
	e1:SetTarget(c91211.target)
	e1:SetOperation(c91211.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCondition(c91211.condition2)
	c:RegisterEffect(e2)
end
function c91211.afilter(c)
	return c:IsFaceup() and c:IsSetCard(0x404)
end
function c91211.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and Duel.IsExistingMatchingCard(c91211.afilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler()) 
end
function c91211.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c91211.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,91400,0,0x4011,0,0,2,RACE_BEAST,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c91211.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,91400,0,0x4011,0,0,2,RACE_BEAST,ATTRIBUTE_EARTH) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,91400)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
end