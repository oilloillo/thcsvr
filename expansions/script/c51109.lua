--摇曳百合✿杉浦绫乃
function c51109.initial_effect(c)
   	--Pendulum
	aux.EnablePendulumAttribute(c)
	--scale
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CHANGE_LSCALE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCondition(c51109.sccon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e5)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(51109,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c51109.cost)
	e2:SetTarget(c51109.tdtg2)
	e2:SetOperation(c51109.tdop2)
	c:RegisterEffect(e2)
	end
function c51109.costfilter(c)
	return c:IsCode(51107) and c:IsAbleToDeckAsCost()
end
function c51109.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51109.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c51109.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c51109.tdfilter2(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function c51109.tdtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and c51109.tdfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c51109.tdfilter2,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c51109.tdfilter2,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c51109.tdop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function c51109.sccon(e)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return tc and tc:IsCode(51105)
end