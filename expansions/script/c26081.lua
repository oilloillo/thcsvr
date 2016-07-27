--伞符『雨伞的星之交响』
function c26081.initial_effect(c)
	--ritsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26081.target)
	e1:SetOperation(c26081.activate)
	c:RegisterEffect(e1)
	--xyzsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26081,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c26081.scost)
	e2:SetTarget(c26081.stg)
	e2:SetOperation(c26081.sop)
	c:RegisterEffect(e2)
end
function c26081.filter(c,e,tp,m)
	if not c:IsSetCard(0x229) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) then return false end
	local mg=nil
	if c.mat_filter then
		mg=m:Filter(c.mat_filter,c)
	else
		mg=m:Clone()
		mg:RemoveCard(c)
	end
	return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
end
function c26081.mfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c26081.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,0,nil)
		local mg2=Duel.GetMatchingGroup(c26081.mfilter,tp,LOCATION_HAND,0,nil)
		mg1:Merge(mg2)
		return Duel.IsExistingMatchingCard(c26081.filter,tp,LOCATION_DECK,0,1,nil,e,tp,mg1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c26081.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,0,nil)
	local mg2=Duel.GetMatchingGroup(c26081.mfilter,tp,LOCATION_HAND,0,nil)
	mg1:Merge(mg2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c26081.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,mg1)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		mg1:RemoveCard(tc)
		if tc.mat_filter then
			mg1=mg1:Filter(tc.mat_filter,nil)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg1:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
		tc:SetMaterial(mat)
		local dic=mat:Filter(Card.IsLocation,nil,LOCATION_HAND)
		Duel.SendtoGrave(dic,REASON_EFFECT+REASON_MATERIAL+REASON_DISCARD)
		mat:Sub(dic)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c26081.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,1,REASON_COST)
end
function c26081.filter1(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsSetCard(0x208)
end
function c26081.filter2(c,e,tp,mg)
	return c:IsSetCard(0x229) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:IsType(TYPE_XYZ)--and c:IsXyzSummonable(mg)
end
function c26081.stg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c26081.filter1(chkc) end
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c26081.filter1,tp,LOCATION_MZONE,0,nil)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingTarget(c26081.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c26081.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)
		and Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)==1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,c26081.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
end
function c26081.sop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) then return end
	local mg=Duel.GetMatchingGroup(c26081.filter1,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c26081.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg)
	local sc=g:GetFirst()
	if sc then
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
