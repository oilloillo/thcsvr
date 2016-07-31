 
--现人神 东风谷早苗
function c23021.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c23021.spcon)
	e1:SetOperation(c23021.spop)
	c:RegisterEffect(e1)
    --sp summon success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23021,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCondition(c23021.con)
	e2:SetTarget(c23021.tg)
	e2:SetOperation(c23021.op)
	c:RegisterEffect(e2)
end
function c23021.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c23021.spcon(e,c)
	if c==nil then return true end
	return (Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c23021.cfilter,c:GetControler(),LOCATION_MZONE+LOCATION_HAND,0,1,e:GetHandler()))
		or (Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)==0
		and Duel.IsExistingMatchingCard(c23021.cfilter,c:GetControler(),LOCATION_MZONE,0,1,e:GetHandler()))
end
function c23021.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local mc=Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)
	if mc>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c23021.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,e:GetHandler())
		Duel.SendtoDeck(g,nil,1,REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c23021.cfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
		Duel.SendtoDeck(g,nil,1,REASON_COST)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c23021.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()==0
end
function c23021.filter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c23021.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c23021.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c23021.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c23021.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
