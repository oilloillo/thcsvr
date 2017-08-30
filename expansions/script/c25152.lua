--花符『幻想乡的开花』
function c25152.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,25152+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c25152.condition)
	e1:SetTarget(c25152.target)
	e1:SetOperation(c25152.activate)
	c:RegisterEffect(e1)
end
function c25152.cfilter(c)
	return c:IsFaceup() and c:IsCode(10000)
end
function c25152.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c25152.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c25152.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)+Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if chk==0 then return ct>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,25162,0x208,0x4011,0,800,1,RACE_PLANT,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,0,0)
end
function c25152.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if ct1+ct2<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,25162,0x208,0x4011,0,800,1,RACE_PLANT,ATTRIBUTE_WIND) then
		for i = 1,ct1 do
			local token=Duel.CreateToken(tp,25162)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
		for i = 1,ct2 do
			local token=Duel.CreateToken(tp,25162)
			Duel.SpecialSummonStep(token,0,1-tp,1-tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
end
