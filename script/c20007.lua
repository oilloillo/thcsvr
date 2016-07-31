 
--爱丽丝·玛格特罗依德
function c20007.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20007,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c20007.ntcon)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c20007.val)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(20007,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c20007.spcost)
	e3:SetTarget(c20007.sptg)
	e3:SetOperation(c20007.spop)
	c:RegisterEffect(e3)
end
function c20007.ntcon(e,c)
	if c==nil then return true end
	return c:GetLevel()>4
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c20007.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD)
end
function c20007.filter(c,e,tp)
	return c:IsSetCard(0x186) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(2)
end
function c20007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c20007.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c20007.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(c20007.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,2,2,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		local tc=sg:GetFirst()
		tc:RegisterFlagEffect(20007,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		tc=sg:GetNext()
		tc:RegisterFlagEffect(20007,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		sg:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(sg)
		e1:SetOperation(c20007.desop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c20007.desfilter(c)
	return c:GetFlagEffect(20007)>0
end
function c20007.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c20007.desfilter,nil)
	g:DeleteGroup()
	Duel.Destroy(tg,REASON_EFFECT)
end
function c20007.val(e,c)
	return Duel.GetMatchingGroupCount(c20007.afilter,c:GetControler(),LOCATION_ONFIELD,0,nil)*200
end
function c20007.afilter(c)
	return c:IsFaceup() and c:IsSetCard(0x186)
end
