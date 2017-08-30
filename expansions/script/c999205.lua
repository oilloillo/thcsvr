--虚史「幻想乡传说」　
function c999205.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetDescription(aux.Stringid(999205,0))
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9992051)
	e1:SetCondition(c999205.condition)
	e1:SetTarget(c999205.target)
	e1:SetOperation(c999205.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(999205,1))
	e2:SetCountLimit(1,9992052)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c999205.thcost)
	e2:SetCondition(c999205.thcon)
	e2:SetTarget(c999205.thtg)
	e2:SetOperation(c999205.thop)
	c:RegisterEffect(e2)
end
function c999205.condition(e,tp,eg,ep,ev,re,r,rp)
	local phase = Duel.GetCurrentPhase()
	return phase == PHASE_MAIN1 or phase == PHASE_MAIN2
end
function c999205.filter1(c, e, tp)
	return c:IsType(TYPE_DUAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c999205.filter2(c)
	return c:IsType(TYPE_DUAL) and c:IsAbleToHand()
end
function c999205.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	local flag1 = Duel.IsExistingMatchingCard(Card.IsAbleToRemove, tp, LOCATION_MZONE, 0, 1, c) 
			and Duel.IsExistingMatchingCard(c999205.filter1, tp, LOCATION_DECK, 0, 1, nil, e, tp)
	local flag2 = Duel.IsExistingMatchingCard(Card.IsAbleToRemove, tp, LOCATION_HAND, 0, 1, c) 
			and Duel.IsExistingMatchingCard(c999205.filter2, tp, LOCATION_DECK, 0, 1, nil)
	if chk==0 then return flag1 or flag2 end
end
function c999205.operation(e,tp,eg,ep,ev,re,r,rp)
	-- setdata
	local c = e:GetHandler()
	local t = {}
	t.cg1 = Duel.GetMatchingGroup(Card.IsAbleToRemove, tp, LOCATION_MZONE, 0, c)
	t.tg1 = Duel.GetMatchingGroup(c999205.filter1, tp, LOCATION_DECK, 0, nil, e, tp)
	t.cg2 = Duel.GetMatchingGroup(Card.IsAbleToRemove, tp, LOCATION_HAND, 0, c)
	t.tg2 = Duel.GetMatchingGroup(c999205.filter2, tp, LOCATION_DECK, 0, nil)
	t.op1 = function (g) 
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) 
			end
	t.op2 = function (g) 
				Duel.SendtoHand(g,nil,REASON_EFFECT) 
				Duel.ConfirmCards(1-tp,g)
			end
	-- select
	local tempg = Group.CreateGroup()
	for i=1,2 do
		if t["cg"..i]:GetCount()>0 and t["tg"..i]:GetCount()>0 then
			tempg:Merge(t["cg"..i])
		end
	end
	sg = tempg:Select(tp, 1, 1, c)
	-- process
	local loc = sg:GetFirst():GetLocation()
	Duel.Remove(sg, POS_FACEUP, REASON_EFFECT)
	if sg:GetCount()==1 then
		local tip1 = (loc == LOCATION_MZONE and HINTMSG_SPSUMMON or HINTMSG_ATOHAND)
		local tip2 = (loc == LOCATION_MZONE and 1 or 2)
		Duel.Hint(HINT_SELECTMSG,tp, tip1)
		local filter = c999205["filter"..tip2]
		local op = t["op"..tip2]
		local g1=Duel.SelectMatchingCard(tp, filter,tp,LOCATION_DECK,0,1,1,nil, e, tp)
		op(g1)
	end
end
function c999205.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c999205.thfilter(c)
	return c:IsType(TYPE_DUAL) and c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c999205.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c999205.thfilter, tp, LOCATION_MZONE, 0, 1, nil)
end
function c999205.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk==0 then return c:IsAbleToHand() and c:IsLocation(LOCATION_GRAVE) end
	e:GetHandler():CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c999205.thop(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end