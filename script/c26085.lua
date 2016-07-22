--雨符『雨夜怪谈』
function c26085.initial_effect(c)
	--Activate1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26085,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,26084)
	e1:SetTarget(c26085.target1)
	e1:SetOperation(c26085.activate1)
	c:RegisterEffect(e1)
	--Activate2
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(26085,1))
	e2:SetCondition(c26085.condition)
	--e2:SetCost(c26085.cost)
	e2:SetTarget(c26085.target2)
	e2:SetOperation(c26085.activate2)
	c:RegisterEffect(e2)
end
function c26085.filter(c,e,tp)
	return c:IsSetCard(0x229) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENCE)
end
function c26085.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingTarget(c26085.filter,tp,LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c26085.filter,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
end
function c26085.activate1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()~=2 then return end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENCE)
	Duel.ShuffleSetCard(sg)
end
function c26085.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
		and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
end
function c26085.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c26085.spfilter(c,e,tp,type)
	return c:IsType(type) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:IsType(TYPE_FLIP)
end
function c26085.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=3
		and Duel.IsExistingTarget(c26085.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,TYPE_FUSION)
		and Duel.IsExistingTarget(c26085.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,TYPE_RITUAL)
		and Duel.IsExistingTarget(c26085.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,TYPE_XYZ) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c26085.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,TYPE_FUSION)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c26085.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,TYPE_RITUAL)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g3=Duel.SelectTarget(tp,c26085.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,TYPE_XYZ)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,3,0,0)
end
function c26085.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if g:GetCount()>ft then return end
	Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENCE)
end
