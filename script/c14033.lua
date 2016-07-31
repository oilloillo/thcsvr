 
--Lotus Love
function c14033.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c14033.cost)
	e1:SetTarget(c14033.target)
	e1:SetOperation(c14033.activate)
	c:RegisterEffect(e1)
end
function c14033.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,14033)==0 end
	Duel.RegisterFlagEffect(tp,14033,RESET_PHASE+PHASE_END,0,1)
end
function c14033.filter(c)
	local atk=c:GetAttack()
	return atk>=0 and atk<=2000 and c:IsSetCard(0x138) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c14033.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c14033.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c14033.filter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c14033.filter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function c14033.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
