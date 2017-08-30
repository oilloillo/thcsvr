 
--古代的尸解仙 物部布都
function c27013.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c27013.spcon)
	e1:SetOperation(c27013.spop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27013,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c27013.cost)
	e2:SetTarget(c27013.target)
	e2:SetOperation(c27013.operation)
	c:RegisterEffect(e2)
end
function c27013.spfilter(c)
	return c:IsFaceup() and c:IsAbleToHandAsCost() and c:IsCode(27010)
end
function c27013.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c27013.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c27013.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c27013.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c27013.cfilter(c)
	return c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(6)
end
function c27013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27013.cfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c27013.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c27013.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c27013.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g1,REASON_COST)
	Duel.SendtoGrave(g2,REASON_COST)
end
function c27013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c27013.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
