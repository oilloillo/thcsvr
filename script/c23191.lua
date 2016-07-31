--山上的新人神明✿东风谷早苗
function c23191.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23191,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c23191.cost)
	e1:SetTarget(c23191.tg)
	e1:SetOperation(c23191.op)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23191,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CHAIN_UNIQUE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,23191)
	e2:SetTarget(c23191.settg)
	e2:SetOperation(c23191.setop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c23191.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c23191.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23191.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c23191.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function c23191.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c23191.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		c:AddCounter(0x28a,1)
		if Duel.GetFlagEffect(tp,23200)==0 then
			Duel.RegisterFlagEffect(tp,23200,0,0,0)
		end
	end
end
function c23191.ssfilter(c)
	return c:IsSetCard(0x496) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c23191.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,23200)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():GetOverlayTarget()==nil
		and Duel.IsExistingMatchingCard(c23191.ssfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c23191.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c23191.ssfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end
