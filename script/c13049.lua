 
--Strawberry Crisis!!
function c13049.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c13049.destg)
	e1:SetOperation(c13049.desop)
	c:RegisterEffect(e1)
	--sol
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetTarget(c13049.thtg)
	e1:SetOperation(c13049.thop)
	c:RegisterEffect(e1)
end
function c13049.dfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c13049.desfilter(c,c1)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable() and c~=c1
end
function c13049.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c13049.dfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) and Duel.IsExistingTarget(c13049.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c13049.dfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,c13049.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler(),g1:GetFirst())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
end
function c13049.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local g2=Duel.GetMatchingGroupCount(c13049.dfilter,tp,LOCATION_DECK,0,nil)
	if Duel.Destroy(g,REASON_EFFECT) and g2>0 and Duel.SelectYesNo(tp,aux.Stringid(13049,0)) then
		sg2=Duel.SelectMatchingCard(tp,c13049.dfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.Destroy(sg2,REASON_EFFECT)
	end
end
function c13049.tgfilter(c)
	return c:IsCode(13021) and c:IsAbleToHand()
end
function c13049.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c13049.tgfilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c13049.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c13049.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
