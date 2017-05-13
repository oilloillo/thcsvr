--无意识的破坏冲动
function c7001101.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7001101,0))
	e1:SetCategory(CATEGORY_COIN+CATEGORY_DESTROY+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c7001101.tg)
	e1:SetOperation(c7001101.activate)
	c:RegisterEffect(e1)
end
function c7001101.filter(c)
	return c:IsDestructable() or c:IsAbleToHand() 
end
function c7001101.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7001101.filter,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_COIN,g,1,0,0)
end
function c7001101.activate(e,tp,eg,ep,ev,re,r,rp)
	local res=Duel.TossCoin(tp,1)
	if res==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,1,e:GetHandler())
		Duel.Destroy(g,REASON_EFFECT)
	else 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,1,e:GetHandler())
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
