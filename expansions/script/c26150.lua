--圣辇船
function c26150.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c26150.activate)
	c:RegisterEffect(e1)
	--sset
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26150,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c26150.scost)
	e2:SetTarget(c26150.stg)
	e2:SetOperation(c26150.sop)
	c:RegisterEffect(e2)
end
function c26150.filter(c)
	return c:IsSetCard(0x252a) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c26150.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c26150.filter,tp,LOCATION_DECK,0,nil)
	if Duel.GetMatchingGroupCount(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(26150,0)) then
		Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c26150.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c26150.sfilter(c)
	return c:GetOriginalCode()==26050 and c:IsSSetable()
end
function c26150.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26150.sfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c26150.sop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c26150.sfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end
