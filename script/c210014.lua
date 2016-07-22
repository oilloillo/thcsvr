--茨华仙的修验场
function c210014.initial_effect(c)
	c:SetUniqueOnField(1,0,210014)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--fusion
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(210014,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c210014.cost)
	e1:SetTarget(c210014.ftg)
	e1:SetOperation(c210014.fop)
	c:RegisterEffect(e1)
	--synchro
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(210014,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c210014.cost)
	e1:SetTarget(c210014.stg)
	e1:SetOperation(c210014.sop)
	c:RegisterEffect(e1)
	--XYZ
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(210014,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c210014.cost)
	e1:SetTarget(c210014.xtg)
	e1:SetOperation(c210014.xop)
	c:RegisterEffect(e1)
end
function c210014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(210014)==0 end
	e:GetHandler():RegisterFlagEffect(210014,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c210014.ffilter1(c)
	return c:IsSetCard(0x710) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c210014.ffilter2(c)
	return c:IsType(TYPE_SPELL) and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and c:IsAbleToRemove() and c:IsFaceup()
end
function c210014.ffilter3(c,e,tp)
	return c:IsSetCard(0x2710) and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function c210014.ftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=0
		and Duel.IsExistingTarget(c210014.ffilter1,tp,LOCATION_ONFIELD,0,1,nil) 
		and Duel.IsExistingTarget(c210014.ffilter2,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(c210014.ffilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c210014.ffilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,c210014.ffilter2,tp,LOCATION_ONFIELD,0,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c210014.ffilter4(c)
	return c:IsOnField() and c:IsAbleToRemove()
end
function c210014.fop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if tg:Filter(c210014.ffilter4,nil):GetCount()==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,c210014.ffilter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
		if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)~=0 then tc:CompleteProcedure() end
	end
end
function c210014.sfilter1(c)
	return c:IsSetCard(0x710) and c:IsType(TYPE_MONSTER)
end
function c210014.sfilter2(c)
	return c:IsType(TYPE_SPELL) and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and c:IsFaceup()
end
function c210014.sfilter3(c,e,tp)
	return c:IsSetCard(0x2710) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c210014.stg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=0
		and Duel.IsExistingTarget(c210014.sfilter1,tp,LOCATION_ONFIELD,0,1,nil) 
		and Duel.IsExistingTarget(c210014.sfilter2,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(c210014.sfilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectTarget(tp,c210014.sfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectTarget(tp,c210014.sfilter2,tp,LOCATION_ONFIELD,0,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c210014.sfilter4(c)
	return c:IsOnField()
end
function c210014.sop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if tg:Filter(c210014.sfilter4,nil):GetCount()==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,c210014.sfilter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
		Duel.SendtoGrave(tg,REASON_EFFECT)
		Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c210014.xfilter1(c)
	return c:IsSetCard(0x710) and c:IsType(TYPE_MONSTER)
end
function c210014.xfilter2(c)
	return c:IsType(TYPE_SPELL) and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and c:IsFaceup()
end
function c210014.xfilter3(c,e,tp)
	return c:IsSetCard(0x2710) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c210014.xtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=0
		and Duel.IsExistingTarget(c210014.xfilter1,tp,LOCATION_ONFIELD,0,1,nil) 
		and Duel.IsExistingTarget(c210014.xfilter2,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(c210014.xfilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g1=Duel.SelectTarget(tp,c210014.xfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g2=Duel.SelectTarget(tp,c210014.xfilter2,tp,LOCATION_ONFIELD,0,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c210014.xfilter4(c)
	return c:IsOnField()
end
function c210014.xop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if tg:Filter(c210014.xfilter4,nil):GetCount()==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,c210014.xfilter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
		local og=tg:Filter(Card.IsLocation,nil,LOCATION_MZONE):GetFirst():GetOverlayGroup()
		if og:GetCount()~=0 then Duel.SendtoGrave(og,REASON_RULE) end
		Duel.Overlay(tc,tg)
		Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end