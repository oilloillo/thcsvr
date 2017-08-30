--梦幻馆 不想起床✿幽香
function c14056.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14056,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c14056.destg)
	e1:SetOperation(c14056.desop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(14056,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetTarget(c14056.target)
	e2:SetOperation(c14056.operation)
	c:RegisterEffect(e2)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c14056.efilter)
	e4:SetCondition(c14056.tecon)
	c:RegisterEffect(e4)
end
function c14056.thfilter(c)
	return c:IsCode(14035) and c:IsAbleToHand()
end
function c14056.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c14056.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c14056.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	else
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
function c14056.filter(c,e,tp)
	return c:IsCode(14013) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c14056.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c14056.filter,tp,0x11,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x11)
end
function c14056.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c14056.filter,tp,0x11,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end
function c14056.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c14056.cfilter(c)
	return c:IsCode(14035) and c:IsFaceup()
end
function c14056.tecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c14056.cfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
end
