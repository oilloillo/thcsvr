 
--七曜-水木符「水精灵」
function c888170.initial_effect(c)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(888170,1))
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,22170)
	e4:SetCost(c888170.cost)
	e4:SetTarget(c888170.target)
	e4:SetOperation(c888170.operation)
	c:RegisterEffect(e4)
end
function c888170.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,300) end
	Duel.PayLPCost(tp,300)
end
function c888170.filter(c)
	return c:IsSetCard(0x177) and c:IsType(TYPE_SPELL) and c:IsSSetable(true)
end
function c888170.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		and Duel.IsExistingMatchingCard(c888170.filter,tp,LOCATION_DECK,0,1,nil)
			and Duel.IsExistingMatchingCard(c888170.filter,tp,LOCATION_GRAVE,0,1,nil) end
end
function c888170.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g1=Duel.SelectMatchingCard(tp,c888170.filter,tp,LOCATION_DECK,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c888170.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		g1:Merge(g2)
		Duel.SSet(tp,g1)
		Duel.ConfirmCards(1-tp,g1)
	end
end
