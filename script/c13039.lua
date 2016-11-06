 --Tabula rasa
function c13039.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c13039.target)
	e1:SetOperation(c13039.activate)
	c:RegisterEffect(e1)
	--sol
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetTarget(c13039.thtg)
	e2:SetOperation(c13039.thop)
	c:RegisterEffect(e2)
end
function c13039.filter(c)
	return c:GetSequence()<5 and c:IsDestructable()
end
function c13039.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) 
		and Duel.GetMatchingGroupCount(c13039.filter,tp,LOCATION_SZONE,0,e:GetHandler())+Duel.GetMatchingGroupCount(Card.IsDestructable,tp,LOCATION_HAND,0,e:GetHandler())>0 
		and Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_HAND,nil) > Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_HAND,0,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,PLAYER_ALL,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c13039.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND+LOCATION_SZONE,0,1,1,e:GetHandler())
	local g2=Duel.SelectMatchingCard(1-tp,aux.TRUE,tp,0,LOCATION_HAND+LOCATION_SZONE,1,1,nil)
	g1:Merge(g2)
	Duel.Destroy(g1,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end
function c13039.tgfilter(c)
	return c:IsSetCard(0x13a) and c:IsAbleToHand()
end
function c13039.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c13039.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c13039.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c13039.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
