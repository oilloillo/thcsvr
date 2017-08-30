 
--人界剑「悟入幻想」
function c20068.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c20068.condition1)
	e1:SetTarget(c20068.target1)
	e1:SetOperation(c20068.activate1)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c20068.condition2)
	e2:SetTarget(c20068.target2)
	e2:SetOperation(c20068.activate2)
	c:RegisterEffect(e2)
end
function c20068.cfilter(c)
	return c:IsFaceup() and c:IsCode(10000)
end
function c20068.condition1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c20068.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c20068.filter1(c)
	return (c:GetOriginalCode()==(20050) or c:GetOriginalCode()==(20088)) and c:IsAbleToHand()
end
c20068[0]=true
c20068[1]=true
function c20068.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c20068[tp] and Duel.IsExistingMatchingCard(c20068.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	c20068[tp]=false
end
function c20068.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c20068.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c20068.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c20068.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c20068.filter2(c)
	return c:IsSetCard(0x713) and c:IsAbleToHand()
end
function c20068.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20068.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c20068.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c20068.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
