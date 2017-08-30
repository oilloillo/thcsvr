--伞符『单脚投手返』
function c26093.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26093)
	e1:SetTarget(c26093.target)
	e1:SetOperation(c26093.activate)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26093,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DISCARD)
	e2:SetCountLimit(1,26093)
	e2:SetTarget(c26093.thtg)
	e2:SetOperation(c26093.thop)
	c:RegisterEffect(e2)
end
function c26093.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return false end
		local g=Duel.GetDecktopGroup(tp,3)
		return g:FilterCount(Card.IsAbleToHand,nil)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,0,LOCATION_DECK)
end
function c26093.thfilter(c)
	return c:IsSetCard(0x229) and c:IsAbleToHand()
end
function c26093.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()>0 then
		--if g:IsExists(c26093.thfilter,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c26093.thfilter,2,2,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
		Duel.ShuffleDeck(tp)
		if Duel.SelectYesNo(tp,aux.Stringid(26093,1)) then
			Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
		end
	end
end
function c26093.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c26093.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
