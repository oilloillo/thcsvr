 
--Rom
function c70042.initial_effect(c)
	--sm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(70042,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c70042.target)
	e1:SetOperation(c70042.operation)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(70042,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c70042.thcost)
	e2:SetTarget(c70042.thtg)
	e2:SetOperation(c70042.thop)
	c:RegisterEffect(e2)
end
function c70042.filter(c)
	return c:IsCode(70047) and c:IsSummonable(true,nil)
end
function c70042.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c70042.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c70042.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c70042.filter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function c70042.thcost(e,tp,eg,ep,ev,re,r,rp,chk)  -- fix
	if chk==0 then return Duel.CheckLPCost(tp,800) and e:GetHandler():IsDiscardable() end
	Duel.PayLPCost(tp,800)
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c70042.thfilter(c)
	return c:IsAbleToHand() and c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c70042.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c70042.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c70042.thfilter,tp,0,LOCATION_ONFIELD,1,nil) end -- fix
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c70042.thfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c70042.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
