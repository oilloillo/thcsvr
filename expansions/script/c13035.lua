 
--梦想超越时空
function c13035.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c13035.cost)
	e1:SetTarget(c13035.target)
	e1:SetOperation(c13035.activate)
	c:RegisterEffect(e1)
end
function c13035.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c13035.filter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsLevelAbove(4) and c:IsAbleToRemoveAsCost()
end
function c13035.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13035.filter,tp,LOCATION_HAND,0,1,nil) and 
		Duel.IsExistingMatchingCard(c13035.cfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c13035.filter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c13035.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c13035.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,c13035.cfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
		Duel.Destroy(g,REASON_EFFECT)
	end
end
