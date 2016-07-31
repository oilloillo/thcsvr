 
--小鬼联盟
function c22084.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c22084.cost)
	e1:SetTarget(c22084.target)
	e1:SetOperation(c22084.activate)
	c:RegisterEffect(e1)
end
function c22084.cfilter(c)
	return c:GetDefence()==900
end
function c22084.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c22084.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroupEx(tp,c22084.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c22084.filter(c)
	local lv=c:GetLevel()
	return c:GetDefence()==900 and lv>0 and lv<4 and c:IsAbleToHand()
end
function c22084.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22084.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c22084.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22084.filter,tp,LOCATION_DECK,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
