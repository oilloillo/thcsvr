--风与湖的通神者✿东风谷早苗
function c23185.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23185,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c23185.ntcon)
	c:RegisterEffect(e1)
	--adc
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(23185,1))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c23185.addct)
	e3:SetOperation(c23185.addc)
	c:RegisterEffect(e3)
	--rit
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23185,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c23185.cost)
	e2:SetTarget(c23185.target)
	e2:SetOperation(c23185.operation)
	c:RegisterEffect(e2)
end
function c23185.ntcon(e,c)
	if c==nil then return true end
	return c:GetLevel()>4
		and Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c23185.xfilter(c)
	return c:IsFaceup() and not c:IsCode(23185)
end
function c23185.addct(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c23185.xfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c23185.xfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SelectTarget(tp,c23185.xfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c23185.addc(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local n=e:GetHandler():GetCounter(0x28a)
	local ct=n+2
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		e:GetHandler():RemoveCounter(tp,0x28a,n,REASON_EFFECT)
		tc:AddCounter(0x28a,ct)
		local cp=tc:GetControler()
		if Duel.GetFlagEffect(cp,23200)==0 then
			Duel.RegisterFlagEffect(cp,23200,0,0,0)
		end
	end
end
function c23185.costfilter(c,lv,tp)
	local lv=c:GetLevel()+c:GetRank()+c:GetCounter(0x28a)
	return lv>=9 and c:IsReleasable() and (c:IsFaceup() or c:IsControler(tp))
end
function c23185.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then ch=1 else ch=nil end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and ((ch==1 and Duel.IsExistingMatchingCard(c23185.costfilter,tp,LOCATION_MZONE,0,1,nil,lv,tp)) or
		Duel.IsExistingMatchingCard(c23185.costfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,lv,tp)) end
	if ch==1 then
		sg=Duel.SelectMatchingCard(tp,c23185.costfilter,tp,LOCATION_MZONE,0,1,1,nil,lv,tp)
	else
		sg=Duel.SelectMatchingCard(tp,c23185.costfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,lv,tp)
		Duel.ReleaseRitualMaterial(sg)
	end
end
function c23185.filter(c,e,tp)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)
end
function c23185.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23185.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c23185.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tg=Duel.SelectMatchingCard(tp,c23185.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if tg:GetCount()>0 then
		Duel.SpecialSummon(tg,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		tg:GetFirst():CompleteProcedure()
	end
end
