---废狱-怨念的地灵✿
function c24086.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24086,0))
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,24086)
	e1:SetCost(c24086.cost)
	e1:SetTarget(c24086.target)
	e1:SetOperation(c24086.operation)
	c:RegisterEffect(e1)
end
function c24086.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c24086.filter(c)
	return c:IsCode(24086) and c:IsAbleToHand()
end
function c24086.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c24086.filter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),tp,LOCATION_DECK)
end
function c24086.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c24086.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
