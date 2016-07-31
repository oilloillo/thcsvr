 
--骚葬「冥河边缘」
function c20117.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--dice
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20117,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c20117.cost)
	e2:SetTarget(c20117.target)
	e2:SetOperation(c20117.operation)
	c:RegisterEffect(e2)
end
function c20117.costfilter(c)
	return c:IsSetCard(0x163) and c:IsAbleToGraveAsCost()
end
function c20117.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20117.costfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c20117.costfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c20117.filter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c20117.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c20117.sfilter(c)
	return c:IsSetCard(0x1828) and c:IsSSetable()
end
function c20117.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local dice=Duel.TossDice(tp,1)
	if dice==3 then
		local dg=Duel.GetMatchingGroup(c20117.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	    Duel.Destroy(dg,REASON_EFFECT)
	elseif dice==6 then
	    Duel.Destroy(e:GetHandler(),REASON_EFFECT,LOCATION_REMOVED)
		Duel.Draw(tp,3,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c20117.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g:GetFirst())
			Duel.ConfirmCards(1-tp,g)
			if g:GetFirst():IsType(TYPE_QUICKPLAY) then
				g:GetFirst():SetStatus(STATUS_SET_TURN,false)
			end
		end
	end
end
