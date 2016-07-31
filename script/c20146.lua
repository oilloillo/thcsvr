 
--京都人形✿
function c20146.initial_effect(c)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20146,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c20146.cost)
	e1:SetTarget(c20146.target)
	e1:SetOperation(c20146.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e2)
	--cannot be battle target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetTarget(c20146.tg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
c20146[0]=true
c20146[1]=true
function c20146.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c20146[tp] and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	c20146[tp]=false
end
function c20146.cfilter(c)
	return not c:IsCode(20146)
end
function c20146.filter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x300)
end
function c20146.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsExistingMatchingCard(c20146.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c20146.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c20146.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c20146.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c20146.tg(e,c)
	return c:IsSetCard(0x300) and c:IsLevelAbove(5)
end
