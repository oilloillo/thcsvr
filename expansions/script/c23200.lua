--风神防护罩 -信仰之力-
function c23200.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c23200.condition)
	e1:SetTarget(c23200.target)
	e1:SetOperation(c23200.activate)
	c:RegisterEffect(e1)
end
function c23200.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.GetFlagEffect(tp,23200)~=0
end
function c23200.filter(c)
	return c:IsAttackPos() and c:IsAbleToDeck()
end
function c23200.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23200.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c23200.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c23200.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c23200.filter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
