 
--空观剑「六根清净斩」
function c20070.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c20070.condition)
	e1:SetTarget(c20070.target)
	e1:SetOperation(c20070.operation)
	c:RegisterEffect(e1)
end
function c20070.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x713)
end
function c20070.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>1 and Duel.CheckChainUniqueness() and Duel.IsExistingMatchingCard(c20070.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c20070.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
end
function c20070.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(p,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(p,1,1,nil)
		local def=sg:GetFirst():GetDefence()
		if def<0 then def=0 end
		if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,def,REASON_EFFECT)
		    Duel.ShuffleHand(1-p)
		else Duel.ShuffleHand(1-p) end
	end
end
