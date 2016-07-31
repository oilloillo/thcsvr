 
--大合葬「灵车大协奏曲怪」
function c20120.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c20120.target)
	e1:SetOperation(c20120.operation)
	c:RegisterEffect(e1)
	if not c20120.global_check then
		c20120.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c20120.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c20120.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if tc:IsSetCard(0x163) then
		Duel.RegisterFlagEffect(rp,20120,RESET_PHASE+PHASE_END,0,1)
	end
end
function c20120.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,20120)>8
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE,0x1c,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,0x1c,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,g:GetCount()*400)
end
function c20120.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,0x1c,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
	Duel.BreakEffect()
	Duel.Damage(1-tp,ct*400,REASON_EFFECT)
end
