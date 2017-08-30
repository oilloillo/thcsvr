 
--剑舞姬-菲雅娜‧雷‧奥地西亚
function c40006.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40006,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FLIP)
	e1:SetTarget(c40006.tg)
	e1:SetOperation(c40006.op)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40006,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c40006.destg)
	e2:SetOperation(c40006.desop)
	c:RegisterEffect(e2)
	--to defence
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40006,2))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(c40006.potg)
	e3:SetOperation(c40006.poop)
	c:RegisterEffect(e3)
end
function c40006.filter(c)
	return c:IsCode(40028) and c:IsAbleToHand()
end
function c40006.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40006.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40006.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c40006.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c40006.tgfilter(c,e,tp)
	return c:IsSetCard(0x430) and not c:IsCode(40006) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40006.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c40006.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c40006.tgfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,0xe,0,1,nil) end
	local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,0xe,0,1,1,nil)
	Duel.SendtoGrave(rg,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c40006.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c40006.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c40006.potg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsAttackPos() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c40006.poop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsAttackPos() and c:IsRelateToEffect(e) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end
