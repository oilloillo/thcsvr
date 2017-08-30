--质能之草莓十字
function c13059.initial_effect(c)
	--boom
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c13059.cost)
	e1:SetTarget(c13059.target)
	e1:SetOperation(c13059.activate)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,13059)
	e2:SetTarget(c13059.thtg)
	e2:SetOperation(c13059.thop)
	c:RegisterEffect(e2)
end
function c13059.cfilter(c)
	return c:IsSetCard(0x13d) and c:IsAbleToGraveAsCost()
end
function c13059.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13059.cfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(c13059.cfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c13059.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c13059.cfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c13059.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c13059.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c13059.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	end
end
function c13059.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(c13059.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g1:GetCount()>0 then
		Duel.Release(g1,REASON_EFFECT)
	end
	if g2:GetCount()>0 then
		Duel.Destroy(g2,REASON_EFFECT)
    end
end
function c13059.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,0,0)
end
function c13059.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(1-tp,Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,1,nil)
	g1:Merge(g2)
	if g1:GetCount()>0 then
		Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
	end
end
