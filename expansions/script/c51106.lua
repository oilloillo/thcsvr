--摇曳百合 结衣
function c51106.initial_effect(c)
	--Pendulum
	aux.EnablePendulumAttribute(c)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(51106,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(2,5110602)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c51106.thtg)
	e2:SetOperation(c51106.thop)
	c:RegisterEffect(e2)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(51106,2))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetProperty(EFFECT_FLAG_REPEAT)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,5110601+EFFECT_COUNT_CODE_DUEL)
	e4:SetCondition(c51106.thcon3)
	e4:SetTarget(c51106.thtg3)
	e4:SetOperation(c51106.thop3)
	c:RegisterEffect(e4)
	end
function c51106.filter(c)
	return c:IsSetCard(0x511) and c:IsAbleToHand() and c:IsFaceup() and c:GetCode()~=51106
end
function c51106.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c51106.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c51106.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c51106.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c51106.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c51106.filter2(c)
	return c:IsCode(51107) and c:IsAbleToGrave()
end
function c51106.thcon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c51106.filter3(c)
	return c:IsSetCard(0x511) and c:IsAbleToHand() and c:GetCode()~=51106
end
function c51106.thtg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsExistingMatchingCard(c51106.filter3,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c51106.thop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c51106.filter3,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end