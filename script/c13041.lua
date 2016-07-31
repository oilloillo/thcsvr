 
--Lost Dream
function c13041.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c13041.rmtg)
	e1:SetOperation(c13041.rmop)
	c:RegisterEffect(e1)
	--sol
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetTarget(c13041.thtg)
	e2:SetOperation(c13041.thop)
	c:RegisterEffect(e2)
end
function c13041.filter(c)
	return c:IsFaceup() and c:IsCode(13009) and c:IsAbleToRemove()
		and Duel.IsExistingTarget(Card.IsAbleToRemove,0,LOCATION_ONFIELD,LOCATION_ONFIELD,2,c)
end
function c13041.exfilter(c,c1)
	return c:IsAbleToRemove() and c~=c1
end
function c13041.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c13041.filter,tp,LOCATION_ONFIELD,0,1,nil) 
		and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,3,e:GetHandler())end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c13041.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,c13041.exfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,3,3,e:GetHandler(),g1:GetFirst())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,g1:GetCount(),0,0)
end
function c13041.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
		e1:SetCode(EFFECT_FORBIDDEN)
		e1:SetTarget(c13041.bantg)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_IGNORE_RANGE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e2:SetTarget(c13041.bantg)
		Duel.RegisterEffect(e2,tp)
	end
end
function c13041.bantg(e,c)
	return c:IsCode(13041) or c:IsCode(13009)
end
function c13041.tgfilter(c)
	return c:IsCode(13009) and c:IsAbleToHand()
end
function c13041.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c13041.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c13041.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c13041.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
