 
--上海人形②✿
function c20150.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20150,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCost(c20150.cost)
	e1:SetTarget(c20150.shtg)
	e1:SetOperation(c20150.shop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20150,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c20150.descon)
	e2:SetTarget(c20150.destg)
	e2:SetOperation(c20150.desop)
	c:RegisterEffect(e2)
end
function c20150.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c20150.filter(c)
	return c:IsSetCard(0x186) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c20150.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,20150)==0 and Duel.IsExistingMatchingCard(c20150.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.RegisterFlagEffect(tp,20150,RESET_PHASE+PHASE_END,0,1)
end
function c20150.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c20150.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c20150.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c20150.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c20150.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c20150.desfilter(chkc) end
	if chk==0 then return Duel.GetFlagEffect(tp,20150)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c20150.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.RegisterFlagEffect(tp,20150,RESET_PHASE+PHASE_END,0,1)
end
function c20150.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
