--光符『无限条光芒』
function c27098.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c27098.cost)
	e1:SetTarget(c27098.target)
	e1:SetOperation(c27098.activate)
	c:RegisterEffect(e1)
end
function c27098.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)<Duel.GetLP(1-tp) and Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c27098.lr(c)
	local lv=0
	if c:GetLevel()>0 then lv=c:GetLevel() end
	if c:GetRank()>0 then lv=c:GetRank() end
	return lv
end
function c27098.mfilter(c,e,slv)
	return c:IsFaceup() and not c:IsImmuneToEffect(e) and c:IsReleasable()
	and c27098.lr(c)<=slv-2
end
function c27098.sfilter(c,e,tp)
	return c:IsSetCard(0x208) and c:IsAttribute(ATTRIBUTE_LIGHT) 
	and bit.band(c:GetType(),0x81)==0x81 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)
	and ((Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c27098.mfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,c:GetLevel()))
	or (Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 and Duel.IsExistingMatchingCard(c27098.mfilter,tp,LOCATION_MZONE,0,1,nil,e,c:GetLevel())))
end
function c27098.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27098.sfilter,tp,LOCATION_HAND,0,1,nil,e,tp)	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c27098.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c27098.sfilter,tp,LOCATION_HAND,0,1,nil,e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c27098.sfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=Group.CreateGroup()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			mat=Duel.SelectMatchingCard(tp,c27098.mfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tc:GetLevel())
		else 
			mat=Duel.SelectMatchingCard(tp,c27098.mfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tc:GetLevel()) 
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(-1000)
		tc:RegisterEffect(e1)
		tc:CompleteProcedure()
	end
end
