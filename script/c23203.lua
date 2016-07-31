--秘术『单脉相传之弹幕』
function c23203.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c23203.damtg)
	e1:SetOperation(c23203.damop)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23203,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c23203.ctcost)
	e2:SetTarget(c23203.cttg)
	e2:SetOperation(c23203.ctop)
	c:RegisterEffect(e2)
end
function c23203.mfilter1(c,e)
	return c:IsSetCard(0x497) and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e) and c:IsAbleToDeck()
end
function c23203.mfilter2(c,e)
	return c:GetCounter(0x28a)>0 and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e) and c:IsAbleToDeck()
end
function c23203.filter2(c,e,tp,m,chkf)
	return c:IsType(TYPE_FUSION) and aux.IsMaterialListSetCard(c,0x497) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		--and (c:CheckFusionMaterial(m,nil,chkf))
end
function c23203.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetMatchingGroup(c23203.mfilter1,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil,e)
	local mg2=Duel.GetMatchingGroup(c23203.mfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	local mg=Group.CreateGroup()
	mg:Merge(mg1)
	mg:Merge(mg2)
	-- local ce=Duel.GetChainMaterial(tp)
	-- local mf=nil
	-- if ce~=nil then
	-- 	local fgroup=ce:GetTarget()
	-- 	local mg3=fgroup(ce,e,tp)
	-- 	mf=ce:GetValue()
	-- end
	local g=Duel.GetMatchingGroup(c23203.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,chkf)
	if chk==0 then
		return g:GetCount()>0 and mg:GetCount()>1 and mg1:GetCount()>0 and mg2:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,0,0x16)
end
function c23203.damop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetMatchingGroup(c23203.mfilter1,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil,e)
	local mg2=Duel.GetMatchingGroup(c23203.mfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	local mg=Group.CreateGroup()
	mg:Merge(mg1)
	mg:Merge(mg2)
	-- local ce=Duel.GetChainMaterial(tp)
	-- local mf=nil
	-- if ce~=nil then
	-- 	local fgroup=ce:GetTarget()
	-- 	local mg3=fgroup(ce,e,tp)
	-- 	mf=ce:GetValue()
	-- end
	local g=Duel.GetMatchingGroup(c23203.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,chkf)
	if g:GetCount()>0 and mg:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		local mat2=mg:Select(tp,1,1,nil)
		Duel.SendtoDeck(mat2,nil,1,REASON_EFFECT)
		mg:RemoveCard(mat2:GetFirst())
		local mat1=mg:Select(tp,1,1,nil)
		Duel.HintSelection(mat1)
		Duel.SendtoDeck(mat1,nil,1,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(c23203.damval)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function c23203.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0
	else return val end
end
function c23203.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c23203.ctfilter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x28a,2)
end
function c23203.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c23203.ctfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c23203.ctfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(23203,1))
	Duel.SelectTarget(tp,c23203.ctfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0x28a)
end
function c23203.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x28a,2)
	end
end
