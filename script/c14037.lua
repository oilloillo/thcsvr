 
--无法避免的禁忌游戏
function c14037.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c14037.target)
	e1:SetOperation(c14037.activate)
	c:RegisterEffect(e1)
end
function c14037.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,PLAYER_ALL,1)
end
function c14037.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	d1=Duel.TossDice(tp,1)
	d2=Duel.TossDice(1-tp,1)
	d3=Duel.Damage(tp,d2*200,REASON_EFFECT)
	Duel.Damage(1-tp,d1*200,REASON_EFFECT)
	if not c:IsRelateToEffect(e) or not c:IsCanTurnSet() then return end
		if d3>=400 then
			Duel.BreakEffect()
			c:CancelToGrave()
			Duel.ChangePosition(c,POS_FACEDOWN)
			Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
end
