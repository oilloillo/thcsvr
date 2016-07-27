--毒符『毒蛾的鳞粉』
function c21145.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c21145.cost)
	e1:SetTarget(c21145.target)
	e1:SetOperation(c21145.activate)
	c:RegisterEffect(e1)
end
function c21145.filter(c)
	return math.abs(c:GetAttack()-c:GetDefence())==200 or math.abs(c:GetAttack()-c:GetDefence())==2000
end
function c21145.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c21145.filter,1,e:GetHandler()) end
	local g=Duel.SelectReleaseGroupEx(tp,c21145.filter,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
	if g:GetFirst():IsSetCard(0x522) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c21145.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
end
function c21145.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	if g:GetCount()==0 then return end
	local rg=g:RandomSelect(tp,1)
	if Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)~=0 then
		rg:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(rg)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetOperation(c21145.retop)
		Duel.RegisterEffect(e1,tp)
		if e:GetLabel()==1 then
			local g=Duel.SelectMatchingCard(tp,Card.IsCanTurnSet,tp,0,LOCATION_MZONE,1,1,nil)
			if g:GetCount()>0 then
				Duel.ChangePosition(g,POS_FACEDOWN_DEFENCE)
			end
		end
	end
end
function c21145.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	Duel.SendtoHand(g,1-tp,REASON_EFFECT)
	g:DeleteGroup()
end
