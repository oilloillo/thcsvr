--平凡陈腐的山彦✿幽谷响子
function c27136.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27136,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c27136.cost)
	e1:SetTarget(c27136.target)
	e1:SetOperation(c27136.operation)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27136,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,27136)
	e2:SetCost(c27136.setcost)
	e2:SetTarget(c27136.settg)
	e2:SetOperation(c27136.setop)
	c:RegisterEffect(e2)
end
function c27136.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c27136.spfilter(c,e,tp)
	return c:GetLevel()==2 and (c:IsRace(RACE_WINDBEAST) or c:IsRace(RACE_BEAST)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function c27136.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.IsExistingMatchingCard(c27136.spfilter,tp,0x42,0,2,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x42)
end
function c27136.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c27136.spfilter,tp,0x42,0,2,2,e:GetHandler(),e,tp)
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
end
function c27136.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c27136.filter(c)
	return c:IsSetCard(0x527b) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c27136.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27136.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c27136.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c27136.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
