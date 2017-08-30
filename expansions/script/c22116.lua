 
--幻世「The·World」
function c22116.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22116,0))
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c22116.condition)
	e1:SetCost(c22116.cost)
	e1:SetOperation(c22116.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22116,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c22116.condition2)
	e2:SetOperation(c22116.operation)
	c:RegisterEffect(e2)
end
function c22116.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x816)
end
function c22116.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22116.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c22116.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 and Duel.GetCurrentPhase()==PHASE_MAIN1 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)
	Duel.RegisterEffect(e2,tp)
end
function c22116.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	    e1:SetType(EFFECT_TYPE_FIELD)
	    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	    e1:SetCode(EFFECT_SKIP_TURN)
	    e1:SetTargetRange(0,1)
	    e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	    Duel.RegisterEffect(e1,tp)
end
function c22116.filter(c)
	return c:IsFaceup() and not c:IsSetCard(0x816)
end
function c22116.condition2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>=1
		and g:IsExists(Card.IsSetCard,1,nil,0x816) 
		and not g:IsExists(c22116.filter,1,nil)
		and Duel.GetTurnPlayer()==tp 
		and Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c22116.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_BP_TWICE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,0)
	Duel.RegisterEffect(e1,tp)
end
