 
--抑制「Super-ego」
function c24038.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c24038.cost)
	e1:SetTarget(c24038.target)
	e1:SetOperation(c24038.activate)
	c:RegisterEffect(e1)
end
function c24038.costfilter(c)
	return c:IsSetCard(0x625)
end
function c24038.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c24038.costfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c24038.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c24038.filter(c,e,tp)
	return c:IsSetCard(0x625) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c24038.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:GetControler()==tp and c24038.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c24038.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c24038.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c24038.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end
