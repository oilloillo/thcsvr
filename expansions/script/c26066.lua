--万年备用伞✿多多良小伞
function c26066.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26066,2))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DISCARD)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c26066.thtg)
	e1:SetOperation(c26066.thop)
	c:RegisterEffect(e1)
	--flip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26066,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FLIP)
	e2:SetTarget(c26066.destg)
	e2:SetOperation(c26066.desop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e3:SetOperation(c26066.flipop)
	c:RegisterEffect(e3)
end
function c26066.thfilter(c)
	return c:IsSetCard(0x306) and c:IsAbleToHand()
end
function c26066.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26066.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26066.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26066.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c26066.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	if e:GetHandler():GetFlagEffect(26066)~=0 then
		e:SetLabel(1)
		e:GetHandler():ResetFlagEffect(26066)
	else
		e:SetLabel(0)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c26066.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
		local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if e:GetLabel()==1 and sg:GetCount()>0 and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(26066,1)) then
			Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)
			local g=sg:Select(tp,1,1,nil)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c26066.flipop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(26066,0,0,0)
end
