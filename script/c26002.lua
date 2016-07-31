 
--星莲-遗忘之伞 多多良小伞
function c26002.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26002,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetOperation(c26002.operation)
	c:RegisterEffect(e1)
	--no damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26002,1))
	e1:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetCondition(c26002.con)
	e1:SetCost(c26002.cost)
	e1:SetOperation(c26002.op)
	c:RegisterEffect(e1)
end
function c26002.filter(c)
	return c:IsSetCard(0x251) and c:IsAbleToHand()
end
function c26002.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.SelectYesNo(1-tp,aux.Stringid(26002,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.Destroy(g,REASON_EFFECT)
	else
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26002.filter,tp,LOCATION_DECK,0,1,1,nil)
	    if g:GetCount()>0 then
		    Duel.SendtoHand(g,nil,REASON_EFFECT)
		    Duel.ConfirmCards(1-tp,g)
	    end
	end
end
function c26002.con(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c26002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c26002.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,0)
end
