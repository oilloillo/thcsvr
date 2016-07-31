 
--七曜-月木符「卫星向日葵」
function c888183.initial_effect(c)
	--posset
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(888183,1))
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetTarget(c888183.target)
	e4:SetOperation(c888183.operation)
	c:RegisterEffect(e4)
end
function c888183.pofilter(c)
	return c:IsPosition(POS_DEFENCE)
end
function c888183.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c888183.pofilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c888183.pofilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c888183.filter(c)
	return c:IsSetCard(0x177) and c:IsType(TYPE_SPELL) and c:IsSSetable(true)
end
function c888183.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c888183.pofilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.ChangePosition(g,POS_FACEUP_ATTACK)
	local ogg=Duel.GetOperatedGroup()
	local ct=ogg:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<ct then ct=Duel.GetLocationCount(tp,LOCATION_SZONE) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=Duel.SelectMatchingCard(tp,c888183.filter,tp,LOCATION_DECK,0,ct,ct,nil)
	if sg:GetCount()>0 then
		Duel.SSet(tp,sg)
		Duel.ConfirmCards(1-tp,sg)
	end
end
