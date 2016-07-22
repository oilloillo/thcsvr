--毒符『猛毒气息』
function c25050.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e1:SetCost(c25050.cost)
	e1:SetTarget(c25050.target)
	e1:SetOperation(c25050.activate)
	c:RegisterEffect(e1)
end
function c25050.filter(c)
	return math.abs(c:GetAttack()-c:GetDefence())==200 or math.abs(c:GetAttack()-c:GetDefence())==2000
end
function c25050.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c25050.filter,2,e:GetHandler()) end
	local g=Duel.SelectReleaseGroupEx(tp,c25050.filter,2,2,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c25050.sfilter(c)
	return c:IsSetCard(0x164) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c25050.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		and Duel.IsExistingMatchingCard(c25050.sfilter,tp,LOCATION_DECK,0,2,nil) end
end
function c25050.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c25050.sfilter,tp,LOCATION_DECK,0,2,2,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
		Duel.ConfirmCards(1-tp,g)
	end
	local c=e:GetHandler()
	c:SetTurnCounter(0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCondition(c25050.damcon)
	e1:SetOperation(c25050.damop)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN,1)
	Duel.RegisterEffect(e1,tp)
end
function c25050.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c25050.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	if(ct<2) then
		ct=ct+1
		c:SetTurnCounter(ct)
		Duel.Damage(1-tp,1500,REASON_EFFECT)
	end
end
