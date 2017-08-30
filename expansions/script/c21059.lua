 
--知识与历史的半兽 上白泽慧音
function c21059.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x208),4,2)
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21059,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c21059.tdcost)
	e1:SetTarget(c21059.tdtg)
	e1:SetOperation(c21059.tdop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21059,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c21059.cost)
	e2:SetTarget(c21059.target)
	e2:SetOperation(c21059.operation)
	c:RegisterEffect(e2)
end
function c21059.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c21059.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c21059.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c21059.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21059.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c21059.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c21059.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
	end
end
function c21059.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() and e:GetHandler():GetOverlayCount()~=0 end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c21059.spfilter(c,e,tp)
	return (c:IsCode(21006) or c:IsCode(21069)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21059.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21059.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_GRAVE)
end
function c21059.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c21059.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
