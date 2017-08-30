--名誉『十二阶之色彩』
function c27092.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27092,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c27092.target)
	e1:SetOperation(c27092.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27092,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,27092)
	e2:SetTarget(c27092.tg)
	e2:SetOperation(c27092.op)
	c:RegisterEffect(e2)
end
function c27092.tfilter(c,lv,e,tp)
	return c:IsType(TYPE_RITUAL) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)
end
function c27092.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x912)
		and Duel.IsExistingMatchingCard(c27092.tfilter,tp,LOCATION_DECK,0,1,nil,12-c:GetLevel(),e,tp)
end
function c27092.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c27092.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c27092.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c27092.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c27092.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c27092.tfilter,tp,LOCATION_DECK,0,1,1,nil,12-tc:GetLevel(),e,tp)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg:GetFirst(),SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		sg:GetFirst():RegisterEffect(e1,true)
		sg:GetFirst():CompleteProcedure()
	end
end
function c27092.thfilter(c)
	return c:IsCode(27093) and c:IsAbleToHand()
end
function c27092.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27092.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c27092.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c27092.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
