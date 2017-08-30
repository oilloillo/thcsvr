--回忆『恐怖催眠术』
function c24104.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetDescription(aux.Stringid(24104,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c24104.condition)
	e1:SetTarget(c24104.target1)
	e1:SetOperation(c24104.activate1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(24104,1))
	e2:SetTarget(c24104.target2)
	e2:SetOperation(c24104.activate2)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(24104,2))
	e3:SetTarget(c24104.target3)
	e3:SetOperation(c24104.activate3)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetDescription(aux.Stringid(24104,3))
	e4:SetTarget(c24104.target4)
	e4:SetOperation(c24104.activate4)
	c:RegisterEffect(e4)
end
function c24104.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x214a)
end
function c24104.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c24104.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c24104.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_HAND)
end
function c24104.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToGrave,tp,0,LOCATION_HAND,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c24104.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_MZONE)
end
function c24104.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToGrave,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c24104.filter3(c)
	return c:GetSequence()<5
end
function c24104.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24104.filter3,tp,0,LOCATION_SZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_SZONE)
end
function c24104.activate3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(1-tp,c24104.filter3,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c24104.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_DECK,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_DECK)
end
function c24104.activate4(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToGrave,1-tp,0,LOCATION_DECK,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
