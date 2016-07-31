 
--森近霖之助
function c10009.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x208),2,2)
	--disable search
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TO_HAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_DECK)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10009,0))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c10009.cost)
	e3:SetTarget(c10009.sctg)
	e3:SetOperation(c10009.scop)
	c:RegisterEffect(e3)
	--disable spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e4:SetDescription(aux.Stringid(10009,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_SPSUMMON)
	e4:SetCondition(c10009.condition)
	e4:SetCost(c10009.cost)
	e4:SetTarget(c10009.target)
	e4:SetOperation(c10009.operation)
	c:RegisterEffect(e4)
end
function c10009.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFacedown()
end
function c10009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10009.filter(c)
	return c:IsSetCard(0x208) and c:IsRace(RACE_SPELLCASTER) and c:IsDefenceBelow(1000) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10009.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10009.filter,tp,LOCATION_DECK,0,1,nil)
		and not Duel.IsExistingMatchingCard(c10009.cfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10009.scop(e,tp,eg,ep,ev,re,r,rp)
	--if Duel.IsExistingMatchingCard(c10009.cfilter,tp,LOCATION_ONFIELD,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10009.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10009.dfilter(c)
	return c:GetLevel()<=4 and c:GetLevel()>0
end
function c10009.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10009.dfilter,1,nil) and Duel.GetCurrentChain()==0
end
function c10009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsExistingMatchingCard(c10009.cfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function c10009.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	--if Duel.IsExistingMatchingCard(c10009.cfilter,tp,LOCATION_ONFIELD,0,1,nil) then return end
	local g=eg:Filter(c10009.dfilter,nil)
	Duel.NegateSummon(g)
	Duel.Destroy(g,REASON_EFFECT)
end
