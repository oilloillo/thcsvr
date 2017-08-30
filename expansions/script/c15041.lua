--天魔界✿露易兹
function c15041.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(15041,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCost(c15041.cost)
	e1:SetTarget(c15041.target)
	e1:SetOperation(c15041.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(15041,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCost(c15041.cost)
	e4:SetTarget(c15041.sptg)
	e4:SetOperation(c15041.spop)
	c:RegisterEffect(e4)
end
function c15041.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fa=Duel.GetFlagEffect(tp,15000)
	local fb=Duel.GetFlagEffect(tp,150000)
	local fc=fa-fb
	if chk==0 then return fc<3 end
	Duel.RegisterFlagEffect(tp,15000,RESET_PHASE+PHASE_END,0,1)
end
function c15041.filter(c)
	return c:IsSetCard(0x150) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c15041.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(0x30) and chkc:IsControler(tp) and c15041.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c15041.filter,tp,0X30,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c15041.filter,tp,0x30,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c15041.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ShuffleHand(tp)
	end
end
function c15041.spfilter(c,e,tp)
	return c:IsSetCard(0x150) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c15041.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c15041.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c15041.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c15041.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
