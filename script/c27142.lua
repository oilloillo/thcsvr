--鸟兽伎乐✿米斯蒂娅萝蕾拉&幽谷响子
function c27142.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x522),aux.FilterBoolFunction(Card.IsSetCard,0x527),false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c27142.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c27142.spcon)
	e2:SetOperation(c27142.spop)
	e2:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,27142)
	e3:SetCondition(c27142.descon)
	e3:SetOperation(c27142.desop)
	c:RegisterEffect(e3)
	--des2
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c27142.dcost)
	e4:SetTarget(c27142.dtg)
	e4:SetOperation(c27142.dop)
	c:RegisterEffect(e4)
end
function c27142.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c27142.mfilter(c,set)
	return c:IsSetCard(set) and
		(c:IsLocation(LOCATION_MZONE) or (c:IsLocation(LOCATION_SZONE) and (c:GetSequence()==6 or c:GetSequence()==7)))
end
function c27142.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg1=Duel.GetMatchingGroup(c27142.mfilter,tp,LOCATION_ONFIELD,0,nil,0x522)
	local mg2=Duel.GetMatchingGroup(c27142.mfilter,tp,LOCATION_ONFIELD,0,nil,0x527)
	local xmg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	local xsg=Group.CreateGroup()
	local xtc=xmg:GetFirst()
	while xtc do
		local xsg1=xtc:GetOverlayGroup()
		xsg:Merge(xsg1)
		xtc=xmg:GetNext()
	end
	local xsg1=xsg:Filter(Card.IsSetCard,nil,0x522)
	local xsg2=xsg:Filter(Card.IsSetCard,nil,0x527)
	mg1:Merge(xsg1)
	mg2:Merge(xsg2)
	local mct1=Duel.GetMatchingGroupCount(c27142.mfilter,tp,LOCATION_MZONE,0,nil,0x522)
	local mct2=Duel.GetMatchingGroupCount(c27142.mfilter,tp,LOCATION_MZONE,0,nil,0x527)
	local mct=0
	if mct1>0 and mct2>0 then mct=-2 end
	return mg1:GetCount()>0 and mg2:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>mct 
		and mg1:GetFirst()~=mg2:GetFirst()
end
function c27142.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg1=Duel.GetMatchingGroup(c27142.mfilter,tp,LOCATION_ONFIELD,0,nil,0x522)
	local mg2=Duel.GetMatchingGroup(c27142.mfilter,tp,LOCATION_ONFIELD,0,nil,0x527)
	local xmg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	local xsg=Group.CreateGroup()
	local xtc=xmg:GetFirst()
	while xtc do
		local xsg1=xtc:GetOverlayGroup()
		xsg:Merge(xsg1)
		xtc=xmg:GetNext()
	end
	local xsg1=xsg:Filter(Card.IsSetCard,nil,0x522)
	local xsg2=xsg:Filter(Card.IsSetCard,nil,0x527)
	mg1:Merge(xsg1)
	mg2:Merge(xsg2)
	local ct1=mg1:GetCount()
	local ct2=mg2:GetCount()
	local mct1=Duel.GetMatchingGroupCount(c27142.mfilter,tp,LOCATION_MZONE,0,nil,0x522)
	local mct2=Duel.GetMatchingGroupCount(c27142.mfilter,tp,LOCATION_MZONE,0,nil,0x527)
	local sg=Group.CreateGroup()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		if ct2>1 then
			sg=mg1:FilterSelect(tp,aux.TRUE,1,1,nil)
		else
			sg=mg1:FilterSelect(tp,aux.TRUE,1,1,mg2:GetFirst())
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg2=mg2:FilterSelect(tp,aux.TRUE,1,1,sg:GetFirst())
		sg:Merge(sg2)
	else
		if mct1==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			if ct2>1 then
				sg=mg1:FilterSelect(tp,aux.TRUE,1,1,nil)
			else
				sg=mg1:FilterSelect(tp,aux.TRUE,1,1,mg2:GetFirst())
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg2=mg2:FilterSelect(tp,Card.IsLocation,1,1,sg:GetFirst(),LOCATION_MZONE)
			sg:Merge(sg2)
		elseif mct2==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			if ct2>1 then
				sg=mg1:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_MZONE)
			else
				sg=mg1:FilterSelect(tp,Card.IsLocation,1,1,mg2:GetFirst(),LOCATION_MZONE)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg2=mg2:FilterSelect(tp,aux.TRUE,1,1,sg:GetFirst())
			sg:Merge(sg2)		
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			if ct2>1 then
				sg=mg1:FilterSelect(tp,aux.TRUE,1,1,nil)
			else
				sg=mg1:FilterSelect(tp,aux.TRUE,1,1,mg2:GetFirst())
			end
			if sg:GetFirst():IsLocation(LOCATION_MZONE) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local sg2=mg2:FilterSelect(tp,aux.TRUE,1,1,sg:GetFirst())
				sg:Merge(sg2)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local sg2=mg2:FilterSelect(tp,Card.IsLocation,1,1,sg:GetFirst(),LOCATION_MZONE)
				sg:Merge(sg2)
			end
		end		
	end
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
function c27142.desfilter1(c)
	return c:IsDestructable() and c:IsFaceup()
end
function c27142.desfilter2(c)
	return c:IsDestructable() and not c:IsFaceup()
end
function c27142.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end
function c27142.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(c27142.desfilter1,tp,0,LOCATION_ONFIELD,nil) 
	local ct2=Duel.GetMatchingGroupCount(c27142.desfilter2,tp,0,LOCATION_ONFIELD,nil) 
	if ct1<1 and ct2<2 then return end
	local sg=Group.CreateGroup()
	if ct1>0 and ct2<2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_HINTMSG_DESTROY)
		sg=Duel.SelectMatchingCard(tp,c27142.desfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_HINTMSG_DESTROY)
		sg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	end
	if sg:GetCount()>0 and not sg:GetFirst():IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_HINTMSG_DESTROY)
		local sg2=Duel.SelectMatchingCard(tp,c27142.desfilter2,tp,0,LOCATION_ONFIELD,1,1,sg:GetFirst())
		sg:Merge(sg2)
	end
	Duel.Destroy(sg,REASON_EFFECT)
end
function c27142.dfilter(c)
	return c:IsDestructable() and c:IsFaceup() and c:IsType(TYPE_MONSTER) and(c:GetLevel()>=4 or c:GetRank()>=4)
end
function c27142.dcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_HAND,0,1,1,nil)
	local sg2=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_MZONE,0,1,1,nil)
	sg:Merge(sg2)
	Duel.Release(sg,REASON_COST)
end
function c27142.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27142.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c27142.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1200)
end
function c27142.dop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Damage(1-tp,1200,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(c27142.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local sg=g:RandomSelect(tp,1)
		Duel.BreakEffect()
		Duel.Destroy(sg,REASON_EFFECT)
	end
end