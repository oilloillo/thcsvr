--转嫁游戏大师✿键山雏
function c23073.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23073,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetCountLimit(1,23073)
	e1:SetCondition(c23073.thcon)
	e1:SetTarget(c23073.thtg)
	e1:SetOperation(c23073.thop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c23073.condtion)
	e2:SetTarget(c23073.target)
	e2:SetOperation(c23073.operation)
	c:RegisterEffect(e2)
end
function c23073.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c23073.thfilter(c)
	return c:IsSetCard(0x113) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c23073.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23073.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c23073.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c23073.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c23073.condtion(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_DECK
end
function c23073.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c23073.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
end
