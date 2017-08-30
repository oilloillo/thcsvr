 
--斯卡雷特编年史
function c22120.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCondition(c22120.condition)
	e1:SetCost(c22120.cost)
	e1:SetTarget(c22120.target)
	e1:SetOperation(c22120.activate)
	c:RegisterEffect(e1)
end
c22120.DescSetName = 0xa3
function c22120.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function c22120.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:IsSetCard(0x813)
end
function c22120.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c22120.costfilter,tp,LOCATION_GRAVE,0,nil)
	-- if chk==0 then return g:GetClassCount(Card.GetCode)>=2 end
	if chk==0 then return g:GetClassCount(Card.GetCode)>=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
	--if Duel.SelectYesNo(tp,aux.Stringid(22120,0)) then
	if g:GetClassCount(Card.GetCode)>=1 and Duel.SelectYesNo(tp,aux.Stringid(22120,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=g:Select(tp,1,1,nil)
		e:SetLabel(2)
		g1:Merge(g2)
	else e:SetLabel(1) end
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c22120.filter(c)
	return c:IsSetCard(0x812) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c22120.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22120.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,e:GetLabel(),tp,LOCATION_DECK)
end
function c22120.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22120.filter,tp,LOCATION_DECK,0,e:GetLabel(),e:GetLabel(),nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
