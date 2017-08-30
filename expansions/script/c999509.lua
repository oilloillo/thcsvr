--冬之妖怪✿蕾蒂
function c999509.initial_effect(c)
	--synchro custom
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetTarget(c999509.syntg)
	e1:SetValue(1)
	e1:SetOperation(c999509.synop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999509,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,999509)
	e2:SetCondition(c999509.spcon)
	e2:SetCost(c999509.spcost)
	e2:SetTarget(c999509.sptg)
	e2:SetOperation(c999509.spop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999509,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c999509.destg)
	e3:SetOperation(c999509.desop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_DESTROYED)
	c:RegisterEffect(e4)
end

c999509.tuner_filter=aux.FALSE

function c999509.synfilter(c,syncard,tuner,f)
	return c:IsFaceup() and c:IsNotTuner() and c:GetSynchroLevel(syncard)>2 and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c))
end

function c999509.syntg(e,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=c:GetSynchroLevel(syncard)-syncard:GetLevel()
	if lv<=0 then return false end
	local g=Duel.GetMatchingGroup(c999509.synfilter,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	return g:CheckWithSumEqual(Card.GetSynchroLevel, lv, minc, maxc, syncard)
end

function c999509.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=c:GetSynchroLevel(syncard)-syncard:GetLevel()
	local g=Duel.GetMatchingGroup(c999509.synfilter,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local sg=g:SelectWithSumEqual(tp, Card.GetSynchroLevel, lv, minc, maxc, syncard)
	Duel.SetSynchroMaterial(sg)
end
--
function c999509.confilter(c)
	return c:GetSequence()>5 or (c:GetSequence()==5 and c:GetOriginalCode()==22090)
end

function c999509.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c999509.confilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
end

function c999509.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,c) end
	Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_COST+REASON_DISCARD,c)
end

function c999509.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c999509.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetOperation(c999509.selfdes)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		c:RegisterEffect(e1)
	end
end

function c999509.selfdes(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
--
function c999509.desfilter(c)
	return c:IsDestructable()
end

function c999509.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999509.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end

function c999509.desop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c999509.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) then return end
	local g=Duel.SelectMatchingCard(tp,c999509.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
