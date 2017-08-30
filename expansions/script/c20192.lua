--天神剑『三魂七魄』
function c20192.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c20192.target)
	e1:SetOperation(c20192.activate)
	c:RegisterEffect(e1)
end
function c20192.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,20046,0x208,0x4011,100,0,1,RACE_ZOMBIE,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c20192.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,20046,0x208,0x4011,100,0,1,RACE_ZOMBIE,ATTRIBUTE_WIND) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	for i=1,2 do
		local token=Duel.CreateToken(tp,20046)
		if not Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then return end
	end
	Duel.SpecialSummonComplete()
	if Duel.SelectYesNo(tp,aux.Stringid(20192,0)) then
		cg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,1,c)
		cg:GetFirst():AddCounter(0x128b,1)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	e1:SetValue(-700)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	e2:SetValue(-700)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c20192.tg)
	e3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	e3:SetValue(1)
	Duel.RegisterEffect(e3,tp)
end
function c20192.tg(e,c)
	return c:IsType(TYPE_SPIRIT)
end
