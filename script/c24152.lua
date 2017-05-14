--无意识的破坏因子
function c24152.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,24152)
	e1:SetTarget(c24152.target)
	e1:SetOperation(c24152.activate)
	c:RegisterEffect(e1)
	--chain done
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c24152.cost)
	e2:SetTarget(c24152.tg)
	e2:SetOperation(c24152.op)
	c:RegisterEffect(e2)
end
function c24152.filter(c)
	return c:IsCode(24152) and c:IsAbleToHand()
end
function c24152.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c24152.activate(e,tp,eg,ep,ev,re,r,rp)
	local ug=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local dg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if ug:GetCount()>0 then
		local rg=ug:RandomSelect(tp,1)
		Duel.Destroy(rg,REASON_EFFECT)
	elseif dg:GetCount()>0 then
		local rg=dg:RandomSelect(tp,1)
		Duel.Destroy(rg,REASON_EFFECT)
	else return end
	if Duel.IsExistingMatchingCard(c24152.filter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(24152,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c24152.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c24152.costfilter(c)
	return c:IsCode(24152) and c:IsAbleToRemoveAsCost()
end
function c24152.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c24152.costfilter, tp, LOCATION_GRAVE, 0, nil)
	if chk==0 then return g:GetCount()>=3 end
	local rg=g:RandomSelect(tp,3)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c24152.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c24152.op(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
