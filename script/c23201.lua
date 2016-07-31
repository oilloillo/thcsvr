--秘术『灰色奇术』
function c23201.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,23201)
	e1:SetTarget(c23201.damtg)
	e1:SetOperation(c23201.damop)
	c:RegisterEffect(e1)
end
function c23201.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c23201.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetOperation(c23201.op)
	Duel.RegisterEffect(e2,tp)
end
function c23201.filter1(c)
	return (c:IsSetCard(0x494) or c:IsSetCard(0x496)) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c23201.mfilter1(c,e)
	return c:IsSetCard(0x497) and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c23201.mfilter2(c,e)
	return c:GetCounter(0x28a)>0 and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c23201.filter2(c,e,tp,m,chkf)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and aux.IsMaterialListSetCard(c,0x497)
		--and c:CheckFusionMaterial(m,nil,chkf)
end
function c23201.mfilter3(c)
	return c:GetCounter(0x28a)>8 and c:IsReleasable()
end
function c23201.filter3(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_EARTH) and bit.band(c:GetType(),0x81)==0x81 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)
end
function c23201.op(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetMatchingGroup(c23201.mfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e)
	local mg2=Duel.GetMatchingGroup(c23201.mfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	mg1:Merge(mg2)
	local g=Duel.GetMatchingGroup(c23201.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,chkf)
	local t={}
	local p=1
	if Duel.IsExistingMatchingCard(c23201.filter1,tp,LOCATION_DECK,0,1,nil) then
		t[p]=aux.Stringid(23201,1) p=p+1
	end
	if g:GetCount()>0 and mg1:GetCount()>0 then
		t[p]=aux.Stringid(23201,2) p=p+1
	end
	if Duel.IsExistingMatchingCard(c23201.mfilter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	and Duel.IsExistingMatchingCard(c23201.filter3,tp,LOCATION_HAND,0,1,nil,e,tp) then
		t[p]=aux.Stringid(23201,3) p=p+1
	end
	if #t==0 then return end
	Duel.Hint(HINT_CARD,0,23201)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(23201,0))
	local sel=Duel.SelectOption(tp,table.unpack(t))+1
	local opt=t[sel]
	if opt==aux.Stringid(23201,1) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c23201.filter1,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	elseif opt==aux.Stringid(23201,2) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		local mat1=mg1:Select(tp,1,1,nil)
		Duel.SendtoGrave(mat1:GetFirst(),REASON_EFFECT+REASON_MATERIAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local tg=Duel.SelectMatchingCard(tp,c23201.mfilter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.ReleaseRitualMaterial(tg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c23201.filter3,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		Duel.SpecialSummon(sg,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		sg:GetFirst():CompleteProcedure()
	end
end
