--绮✿爱丽丝
function c15080.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(15080,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DRAW)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c15080.spcon1)
	e1:SetCost(c15080.spcost)
	e1:SetTarget(c15080.sptg1)
	e1:SetOperation(c15080.spop1)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(15080,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,15080)
	e2:SetCondition(c15080.condition)
	e2:SetCost(c15080.cost)
	e2:SetTarget(c15080.target)
	e2:SetOperation(c15080.activate)
	c:RegisterEffect(e2)
end
function c15080.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c15080.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c15080.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c15080.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function c15080.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetCode()==EVENT_SPSUMMON_SUCCESS and Duel.IsChainNegatable(ev) and ep~=tp
end
function c15080.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c15080.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c15080.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		Duel.RegisterFlagEffect(tp,150000,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(tp,150000,RESET_PHASE+PHASE_END,0,1)
	end
end
