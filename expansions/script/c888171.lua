 
--七曜-木火符「森林大火」
function c888171.initial_effect(c)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(888171,1))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetTarget(c888171.target)
	e4:SetOperation(c888171.operation)
	c:RegisterEffect(e4)
end
function c888171.filter(c)
	return c:IsSetCard(0x180) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsSSetable(true)
end
function c888171.dfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c888171.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>-1
		and Duel.IsExistingMatchingCard(c888171.filter,tp,LOCATION_DECK,0,1,nil) end
	local sg=Duel.GetMatchingGroup(c888171.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,sg:GetCount()*300)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,sg:GetCount()*300)
end
function c888171.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c888171.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
		local sg=Duel.GetMatchingGroup(c888171.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
		local ct=Duel.Destroy(sg,REASON_EFFECT)
--		local og=Duel.GetOperatedGroup()
--		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE+LOCATION_REMOVED)
		Duel.Damage(1-tp,ct*300,REASON_EFFECT)
		Duel.Damage(tp,ct*300,REASON_EFFECT)
	end
end
