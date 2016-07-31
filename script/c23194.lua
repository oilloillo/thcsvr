--孤陋浅薄的人类✿东风谷早苗
function c23194.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23194,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,23194)
	e1:SetCost(c23194.cost)
	e1:SetTarget(c23194.tg)
	e1:SetOperation(c23194.op)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23194,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_CHAIN_UNIQUE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c23194.addct)
	e2:SetOperation(c23194.addc)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c23194.cfilter(c)
	return c:IsAbleToDeckAsCost()
end
function c23194.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23194.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c23194.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function c23194.filter(c,e,tp)
	return c:IsSetCard(0x497) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c23194.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c23194.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c23194.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c23194.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENCE)>0 and e:GetHandler():IsCanAddCounter(0x28a,1) then
		e:GetHandler():AddCounter(0x28a,1)
		if Duel.GetFlagEffect(tp,23200)==0 then
			Duel.RegisterFlagEffect(tp,23200,0,0,0)
		end
	end
end
function c23194.adcfilter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x28a,1)
end
function c23194.addct(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c23194.adcfilter(chkc) end
	if chk==0 then return Duel.GetFlagEffect(tp,23200)>0 and Duel.GetFlagEffect(tp,23194)==0 and e:GetHandler():GetOverlayTarget()==nil
		and Duel.IsExistingTarget(c23194.adcfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c23194.adcfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x28a)
	Duel.RegisterFlagEffect(tp,23194,RESET_PHASE+PHASE_END,0,0)
end
function c23194.addc(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x28a,1)
		local cp=tc:GetControler()
		if Duel.GetFlagEffect(cp,23200)==0 then
			Duel.RegisterFlagEffect(cp,23200,0,0,0)
		end
	end
end
