 
--星莲-遗忘之伞 多多良小伞
function c26004.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26004,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c26004.target)
	e1:SetOperation(c26004.operation)
	c:RegisterEffect(e1)
	--no damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26004,1))
	e1:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c26004.con)
	e1:SetCost(c26004.cost)
	e1:SetOperation(c26004.op)
	c:RegisterEffect(e1)
end
function c26004.filter(c)
	return (c:IsSetCard(0x251) or c:IsSetCard(0x229)) and c:IsAbleToHand()
end
function c26004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil)
	local b=Duel.IsExistingMatchingCard(c26004.filter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return a or b end
end
function c26004.operation(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil)
	local b=Duel.IsExistingMatchingCard(c26004.filter,tp,LOCATION_DECK,0,1,nil)
	if not a and not b then return end
	if a and Duel.SelectYesNo(1-tp,aux.Stringid(26004,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.Destroy(g,REASON_EFFECT)
	elseif b then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c26004.filter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c26004.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetBattleDamage(tp)>0
end
function c26004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c26004.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetOperation(c26004.damop)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c26004.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,0)
end
