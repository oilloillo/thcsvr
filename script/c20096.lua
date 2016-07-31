 
--反魂蝶 -一分咲-
function c20096.initial_effect(c)
	--Activate2
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c20096.target1)
	e1:SetOperation(c20096.activate1)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c20096.target2)
	e2:SetOperation(c20096.activate2)
	c:RegisterEffect(e2)
end
function c20096.xfilter(c)
	return c:IsFaceup() and c:IsCode(20086)
end
function c20096.filter1(c)
	return c:IsCode(20086) and c:IsAbleToHand()
end
function c20096.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsExistingMatchingCard(c20096.xfilter,tp,LOCATION_SZONE,0,1,nil)
	and Duel.IsExistingMatchingCard(c20096.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c20096.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c20096.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT) then
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c20096.filter2(c)
	return c:IsSetCard(0x684) and c:IsAbleToHand() and not c:IsCode(20096)
end
function c20096.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20096.xfilter,tp,LOCATION_SZONE,0,1,nil)
	and Duel.IsExistingMatchingCard(c20096.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c20096.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c20096.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT) then
			Duel.ConfirmCards(1-tp,g)
			if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
				and Duel.SelectYesNo(tp,aux.Stringid(20096,0)) then
				cg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,1,nil)
				cg:GetFirst():AddCounter(0x28b,1)
			end
		end
	end
end
