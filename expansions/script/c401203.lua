--把零战交出来!
function c401203.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(401203,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c401203.cost)
	e1:SetTarget(c401203.target)
	e1:SetOperation(c401203.activate)
	c:RegisterEffect(e1)
end
function c401203.filter(c)
	return c:IsLocation(LOCATION_HAND) and c:IsAbleToRemoveAsCost() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsLevelAbove(5)
end
function c401203.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c401203.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c401203.filter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c401203.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c401203.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	
end