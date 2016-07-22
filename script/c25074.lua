--审判『十王审判』
function c25074.initial_effect(c)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c25074.cost)
	e1:SetTarget(c25074.target)
	e1:SetOperation(c25074.operation)
	c:RegisterEffect(e1)
end
function c25074.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x740) 
end
function c25074.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c25074.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
		and Duel.GetCurrentPhase()==PHASE_MAIN1 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c25074.filter1(c)
	return bit.band(c:GetReason(),REASON_BATTLE)~=0
end
function c25074.filter2(c)
	return bit.band(c:GetReason(),REASON_EFFECT)~=0 and c:GetReasonPlayer()~=c:GetControler()
end
function c25074.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct1=Duel.GetMatchingGroupCount(c25074.filter1,tp,LOCATION_GRAVE,0,nil)
	local ct2=Duel.GetMatchingGroupCount(c25074.filter2,tp,LOCATION_GRAVE,0,nil)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ct1*ct2*600+1200)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct1*ct2*600+1200)
end
function c25074.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct1=Duel.GetMatchingGroupCount(c25074.filter1,tp,LOCATION_GRAVE,0,nil)
	local ct2=Duel.GetMatchingGroupCount(c25074.filter2,tp,LOCATION_GRAVE,0,nil)
	Duel.Damage(p,ct1*ct2*600+1200,REASON_EFFECT)
end
