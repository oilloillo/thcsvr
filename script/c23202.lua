--秘术『遗忘之祭仪』
function c23202.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c23202.damtg)
	e1:SetOperation(c23202.damop)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23202,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c23202.ctcost)
	e2:SetTarget(c23202.cttg)
	e2:SetOperation(c23202.ctop)
	c:RegisterEffect(e2)
end
function c23202.mfilter3(c,tp)
	if c:GetControler()==tp then
		return c:IsReleasable()
	else
		return c:GetCounter(0x28a)>0 and c:IsReleasable()
	end
end
function c23202.rfilter(c)
	return c:GetCounter(0x28a)+c:GetLevel()+c:GetRank()
end
function c23202.filter3(c,e,tp,mg)
	if not c:IsAttribute(ATTRIBUTE_EARTH) or bit.band(c:GetType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) then return false end
	local mg=Duel.GetMatchingGroup(c23202.mfilter3,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,tp):Filter(Card.IsCanBeRitualMaterial,c,c)
	return mg:CheckWithSumGreater(c23202.rfilter,c:GetOriginalLevel(),c)
end
function c23202.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(c23202.mfilter3,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,tp)
	if chk==0 then return Duel.IsExistingMatchingCard(c23202.filter3,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c23202.damop(e,tp,eg,ep,ev,re,r,rp)
local mg=Duel.GetMatchingGroup(c23202.mfilter3,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,tp)
	if Duel.IsExistingMatchingCard(c23202.filter3,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c23202.filter3,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg)
		local tc=sg:GetFirst()
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg:SelectWithSumGreater(tp,c23202.rfilter,tc:GetOriginalLevel(),tc)
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function c23202.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0
	else return val end
end
function c23202.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c23202.ctfilter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x28a,2)
end
function c23202.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c23202.ctfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c23202.ctfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(23202,1))
	Duel.SelectTarget(tp,c23202.ctfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0x28a)
end
function c23202.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x28a,2)
	end
end