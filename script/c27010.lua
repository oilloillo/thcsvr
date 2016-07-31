 
--神明末裔的亡灵 苏我屠自古
function c27010.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c27010.spcon)
	e1:SetOperation(c27010.spop)
	c:RegisterEffect(e1)
	--hand des
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27010,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c27010.cost)
	e2:SetTarget(c27010.target)
	e2:SetOperation(c27010.operation)
	c:RegisterEffect(e2)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e4:SetCondition(c27010.condition)
	e4:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e4)
end
function c27010.spfilter(c)
	return c:IsFaceup() and c:IsAbleToHandAsCost() and c:IsSetCard(0x208) and c:IsLevelBelow(4) and c:IsRace(RACE_ZOMBIE)
end
function c27010.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c27010.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c27010.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c27010.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c27010.cfilter(c)
	return c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x208) and (c:IsRace(RACE_ZOMBIE) or c:IsRace(RACE_ROCK))
end
function c27010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,27010)==0 and Duel.CheckLPCost(tp,800) and Duel.IsExistingMatchingCard(c27010.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.PayLPCost(tp,800) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c27010.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.RegisterFlagEffect(tp,27010,RESET_PHASE+PHASE_END,0,1)
end
function c27010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_HAND)
end
function c27010.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
function c27010.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_BATTLE)
end
