--宵暗小町✿风见幽香
function c25167.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25167,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	--e1:SetHintTiming(0,0x1e0)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c25167.condition)
	e1:SetTarget(c25167.target)
	e1:SetOperation(c25167.operation)
	c:RegisterEffect(e1)
	local e5=e1:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	if not c25167.global_check then
		c25167.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c25167.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(25167,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(c25167.descon)
	e2:SetTarget(c25167.destg)
	e2:SetOperation(c25167.desop)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--multiatk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(25167,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c25167.atkcon)
	e3:SetCost(c25167.atkcost)
	e3:SetTarget(c25167.atktg)
	e3:SetOperation(c25167.atkop)
	c:RegisterEffect(e3)
end
function c25167.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),25167,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function c25167.filter(c,tp)
	return c:GetSummonPlayer()~=tp
end
function c25167.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetFlagEffect(1-tp,25167)==4 and eg:IsExists(c25167.filter,1,nil,tp)) or Duel.GetFlagEffect(1-tp,25167)>4
end
function c25167.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c25167.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c25167.descon(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
	return ct1<ct2
end
function c25167.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c25167.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(g,REASON_EFFECT)
end
function c25167.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=1 and Duel.GetCurrentPhase()==PHASE_MAIN1
		and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_BP)
end
function c25167.rfilter(c)
	return c:IsRace(RACE_PLANT)
end
function c25167.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c25167.rfilter,2,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,c25167.rfilter,2,2,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c25167.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK)==0 end
end
function c25167.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
