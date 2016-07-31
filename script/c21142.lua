--真夜的合唱指挥 米斯蒂娅✿萝蕾拉
--require "expansions/nef/nef"
function c21142.initial_effect(c)
	Nef.AddXyzProcedureWithDesc(c,aux.FilterBoolFunction(Card.IsSetCard,0x208),2,2,aux.Stringid(21142,0))
	--sp2
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetDescription(aux.Stringid(21142,1))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c21142.spcon)
	e1:SetOperation(c21142.spop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21142,2))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c21142.postg)
	e2:SetOperation(c21142.posop)
	c:RegisterEffect(e2)	
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21142,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c21142.fuscost)
	e3:SetTarget(c21142.fustg)
	e3:SetOperation(c21142.fusop)
	c:RegisterEffect(e3)
end
function c21142.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x208) and c:GetOriginalLevel()==2 and bit.band(c:GetOriginalType(),TYPE_TOKEN)~=TYPE_TOKEN
		and (c:IsLocation(LOCATION_MZONE) or (c:IsLocation(LOCATION_SZONE) and (c:GetSequence()==6 or c:GetSequence()==7)))
end
function c21142.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c21142.spfilter,c:GetControler(),LOCATION_ONFIELD,0,2,nil)
end
function c21142.spop(e,tp,eg,ep,ev,re,r,rp,c)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c21142.sumop)
	e1:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c21142.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sg=Duel.SelectMatchingCard(tp,c21142.spfilter,tp,LOCATION_ONFIELD,0,2,2,nil)
	if sg:GetCount()==2 then 
		Duel.Overlay(e:GetHandler(),sg)
	else Duel.SendtoGrave(e:GetHandler(),REASON_RULE) end
end
function c21142.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet() and not (c:IsLocation(LOCATION_SZONE) and (c:GetSequence()==5 or c:GetSequence()==6 or c:GetSequence()==7))
end
function c21142.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mct=Duel.GetMatchingGroup(c21142.posfilter,tp,0,LOCATION_ONFIELD,nil):Filter(Card.IsCanBeEffectTarget,nil,e):GetCount()
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_ONFIELD) and c21142.posfilter(chkc) end
	if chk==0 then return mct>0 and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,mct,REASON_COST)
	local ct=Duel.GetOperatedGroup():GetCount()
	e:SetLabel(ct)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c21142.posfilter,tp,0,LOCATION_ONFIELD,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c21142.posop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local mtg=tg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	local stg=tg:Filter(Card.IsLocation,nil,LOCATION_SZONE)
	if mtg:GetCount()>0 then 
		Duel.ChangePosition(mtg,POS_FACEDOWN_DEFENCE)
	end
	if stg:GetCount()>0 then 
		Duel.ChangePosition(stg,POS_FACEDOWN)
		Duel.RaiseEvent(stg,EVENT_SSET,e,REASON_EFFECT,tp,1-tp,0) 
	end
end
function c21142.filter0(c)
	return c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c21142.filter1(c,e)
	return c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c21142.filter2(c,e,tp,m,f,gc)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m)
		and c:IsRace(RACE_BEAST) and c:IsSetCard(0x208)
end
function c21142.fuscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c21142.fustg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetMatchingGroup(c21142.filter0,tp,LOCATION_GRAVE,0,nil)
		local res=Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.IsExistingMatchingCard(c21142.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,nil)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c21142.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,nil)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c21142.fusop(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetMatchingGroup(c21142.filter1,tp,LOCATION_GRAVE,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c21142.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,nil)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c21142.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,nil)
	end
	if (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and sg1:GetCount()>0) or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil)
			tc:SetMaterial(mat1)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end