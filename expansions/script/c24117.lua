--猫符『怨灵猫乱步』
function c24117.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24117,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c24117.target)
	e1:SetOperation(c24117.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24117,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c24117.target2)
	e2:SetOperation(c24117.activate2)
	c:RegisterEffect(e2)
end
function c24117.filter(c,e,tp)
	return c:IsSetCard(0x115) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c24117.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c24117.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c24117.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c24117.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c24117.cfilter(c)
	return c:GetLevel()==1 and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c24117.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local dis=false
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.IsChainDisablable(0) then
		local g=Duel.GetMatchingGroup(c24117.cfilter,tp,0,LOCATION_HAND,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(24031,1)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT)
			dis=true
		end
	end
	local tc=Duel.GetFirstTarget()
	if not dis and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c24117.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c24117.filter2(c,e,tp,lv)
	return c:IsSetCard(0x115) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(lv)
end
function c24117.filter3(c)
	return c:IsSetCard(0x625) and c:GetLevel()==1 and c:IsType(TYPE_MONSTER)
end
function c24117.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		--local lv=
		--Duel.GetMatchingGroupCount(c24117.filter1,tp,LOCATION_GRAVE,0,nil)+Duel.GetMatchingGroupCount(c24117.filter3,tp,LOCATION_GRAVE,0,nil)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c24117.filter1,tp,LOCATION_GRAVE,0,1,nil) end
		--and Duel.IsExistingMatchingCard(c24117.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,lv) 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,nil,0,0)
end
function c24117.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c24117.filter1,tp,LOCATION_GRAVE,0,1,99,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local lv=g:GetCount()+g:FilterCount(c24117.filter3,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c24117.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
