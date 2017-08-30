--冬天的遗忘之物✿蕾蒂
function c999510.initial_effect(c)
	--synchro custom
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetTarget(c999510.syntg)
	e1:SetValue(1)
	e1:SetOperation(c999510.synop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,999510)
	e2:SetCondition(c999510.spcon)
	e2:SetOperation(c999510.spop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999510,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetTarget(c999510.destg)
	e3:SetOperation(c999510.desop)
	c:RegisterEffect(e3)
end

c999510.tuner_filter=aux.FALSE

function c999510.lvfilter(c, syncard, addlv)
	return c:GetSynchroLevel(syncard)+addlv
end

function c999510.synfilter(c,syncard,tuner,f)
	return c:IsFaceup() and c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c))
end

function c999510.syntg(e,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetSynchroLevel(syncard)
	if lv<=0 then return false end
	local g=Duel.GetMatchingGroup(c999510.synfilter,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	return g:CheckWithSumEqual(c999510.lvfilter, lv, minc, maxc, syncard, c:GetLevel())
end

function c999510.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetSynchroLevel(syncard)
	local g=Duel.GetMatchingGroup(c999510.synfilter,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local sg=g:SelectWithSumEqual(tp, c999510.lvfilter, lv, minc, maxc, syncard, c:GetLevel())
	Duel.SetSynchroMaterial(sg)
end
--
function c999510.confilter(c)
	return c:GetSequence()==5
end

function c999510.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and 
		Duel.IsExistingMatchingCard(c999510.confilter,c:GetControler(),LOCATION_SZONE,0,1,nil)
end

function c999510.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetOperation(c999510.selfdes)
	e1:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
end

function c999510.selfdes(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
--
function c999510.desfilter(c)
	return c:IsDestructable() and c:IsFaceup() and c:GetLevel()>0 and c:GetLevel()<=Duel.GetTurnCount()
end

function c999510.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c999510.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c999510.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c999510.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end

function c999510.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

