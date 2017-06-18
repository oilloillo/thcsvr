--魂符『幽明的苦轮』
function c20193.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c20193.target)
	e1:SetOperation(c20193.activate)
	c:RegisterEffect(e1)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(20193,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1)
	e4:SetCondition(c20193.spcon)
	e4:SetCost(c20193.spcost)
	e4:SetOperation(c20193.spop)
	c:RegisterEffect(e4)
end
function c20193.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,20046,0x208,0x4011,100,0,1,RACE_ZOMBIE,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c20193.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,20046,0x208,0x4011,100,0,1,RACE_ZOMBIE,ATTRIBUTE_WIND) then return end
	local token=Duel.CreateToken(tp,20046)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummonComplete()
end
function c20193.cfilter(c,tp)
	return c:IsType(TYPE_TOKEN) and c:IsRace(RACE_ZOMBIE) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp
end
function c20193.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c20193.cfilter,1,nil,tp) and aux.exccon(e)
end
function c20193.filter(c)
	return c:IsSetCard(0x713) and c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c20193.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(c20193.filter,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c20193.filter,tp,LOCATION_REMOVED,0,1,2,nil)
	Duel.HintSelection(g)
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
	Duel.SendtoGrave(g,REASON_COST+REASON_RETURN)
end
function c20193.spop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e1,tp)
end
