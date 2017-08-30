--古神灵✿厩户丰聪耳
function c27115.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27115,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c27115.spcon)
	e1:SetCost(c27115.cost)
	e1:SetTarget(c27115.target)
	e1:SetOperation(c27115.operation)
	c:RegisterEffect(e1)
	--destroy
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(27115,1))
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCost(c27115.descost)
	e7:SetTarget(c27115.destg)
	e7:SetOperation(c27115.desop)
	c:RegisterEffect(e7)
end
function c27115.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and	Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c27115.cffilter(c)
	return c:IsType(TYPE_RITUAL) and not c:IsPublic()
end
function c27115.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27115.cffilter,tp,LOCATION_HAND,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c27115.cffilter,tp,LOCATION_HAND,0,2,2,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OATH)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c27115.ftarget)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c27115.ftarget(e,c)
	return c:IsLevelAbove(6)
end
function c27115.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c27115.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		c:CompleteProcedure()
	end
end
function c27115.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c27115.filter1(c)
	return c:GetCode()==27111 and c:IsFaceup()
end
function c27115.filter2(c)
	return c:GetCode()==27113 and c:IsFaceup()
end
function c27115.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27115.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c27115.filter2,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c27115.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
