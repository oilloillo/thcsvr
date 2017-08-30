 
--心花「羞于留影的蔷薇」
function c24035.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24035,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c24035.con1)
	e1:SetTarget(c24035.tg1)
	e1:SetOperation(c24035.op1)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24035,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c24035.con2)
	e2:SetTarget(c24035.tg2)
	e2:SetOperation(c24035.op2)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(24035,2))
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c24035.con3)
	e3:SetTarget(c24035.tg3)
	e3:SetOperation(c24035.op3)
	c:RegisterEffect(e3)
end
function c24035.filter(c)
	return c:IsSetCard(0x625) and c:IsFaceup()
end
function c24035.con1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c24035.filter,tp,LOCATION_MZONE,0,nil)
	local gs=g:GetSum(Card.GetLevel)
	return gs>=2
end
function c24035.filter1(c,e,tp)
	return c:IsSetCard(0x625) and c:IsLevelBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c24035.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_HAND) and c24035.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c24035.filter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c24035.filter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c24035.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c24035.con2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c24035.filter,tp,LOCATION_MZONE,0,nil)
	local gs=g:GetSum(Card.GetLevel)
	return gs>=3
end
function c24035.filter2(c)
	return c:IsSetCard(0x625) and c:IsAbleToHand() and c:IsLevelBelow(2)
end
function c24035.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24035.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c24035.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c24035.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c24035.con3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c24035.filter,tp,LOCATION_MZONE,0,nil)
	local gs=g:GetSum(Card.GetLevel)
	return gs>=4
end
function c24035.filter3(c,e,tp)
	return c:IsSetCard(0x625) and c:GetLevel()==1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c24035.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c24035.filter3,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c24035.filter3,tp,LOCATION_GRAVE,0,1,ct,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c24035.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
	    Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
	end
end
