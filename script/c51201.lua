--今年的夏天不可怕
function c51201.initial_effect(c)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(51201,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c51201.con1)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetTarget(c51201.target1)
	e2:SetOperation(c51201.activate1)
	c:RegisterEffect(e2)

	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(51201,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCondition(c51201.con2)
	e3:SetTarget(c51201.tg2)
	e3:SetOperation(c51201.op2)
	c:RegisterEffect(e3)


end
function c51201.con1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c51201.filter,tp,LOCATION_ONFIELD,0,nil)
	local gs=g:GetClassCount(Card.GetCode)
	return gs>=3
end
function c51201.filter3(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c51201.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c51201.filter3,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingTarget(c51201.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=Duel.SelectTarget(tp,c51201.filter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g2=Duel.SelectTarget(tp,c51201.filter3,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
end
function c51201.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c51201.filter(c)
	return c:IsSetCard(0x511) and c:IsFaceup() 
end
function c51201.con2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c51201.filter,tp,LOCATION_ONFIELD,0,nil)
	local gs=g:GetClassCount(Card.GetCode)
	return gs>=2
end
function c51201.filter2(c)
	return c:IsSetCard(0x511) and c:IsAbleToHand()
end
function c51201.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51201.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c51201.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c51201.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

