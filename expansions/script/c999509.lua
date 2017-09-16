--冬之妖怪✿蕾蒂
local M = c999509
local Mid = 999509
function M.initial_effect(c)
	--synchro custom
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetTarget(M.syntg)
	e1:SetValue(1)
	e1:SetOperation(M.synop)
	c:RegisterEffect(e1)

	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(Mid,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,Mid)
	e2:SetCondition(M.spcon)
	e2:SetCost(M.spcost)
	e2:SetTarget(M.sptg)
	e2:SetOperation(M.spop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(Mid,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(M.destg)
	e3:SetOperation(M.desop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_DESTROYED)
	c:RegisterEffect(e4)
end

M.tuner_filter=aux.FALSE

function M.synfilter(c, syncard, tuner, f)
	return c:IsFaceup() and c:IsNotTuner() and c:GetSynchroLevel(syncard) > 2 and c:IsCanBeSynchroMaterial(syncard, tuner) and (f==nil or f(c))
end

function M.matfilter(c, mg, tp, lv, sync, flag)
	if flag and Duel.GetLocationCountFromEx(tp, tp, c) < 1 then return false end
	local val = Card.GetSynchroLevel(c, sync)
	lv = lv - val
	if lv == 0 then return true end
	if lv > 1 then
		local g = mg:Clone()
		g:RemoveCard(c)
		return g:CheckWithSumEqual(Card.GetSynchroLevel, lv, 1, 99, sync)
	end
	return false
end

function M.syntg(e, syncard, f, minc, maxc)
	local c = e:GetHandler()
	local lv = c:GetSynchroLevel(syncard) - syncard:GetLevel()
	if lv <= 0 then return false end
	local tp = c:GetControler()
	local flag = Duel.GetLocationCountFromEx(tp, tp, c) < 1
	local mg = Duel.GetMatchingGroup(M.synfilter, syncard:GetControler(), LOCATION_MZONE, LOCATION_MZONE, c, syncard, c, f)
	return mg:IsExists(M.matfilter, 1, c, mg, tp, lv, syncard, flag)
end

function M.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
	local c = e:GetHandler()
	local tp = c:GetControler()
	local g = Duel.GetMatchingGroup(M.synfilter, syncard:GetControler(), LOCATION_MZONE, LOCATION_MZONE, c, syncard, c, f)
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SMATERIAL)
	local lv = c:GetSynchroLevel(syncard)-syncard:GetLevel()
	local flag = Duel.GetLocationCountFromEx(tp, tp, c) < 1
	local fmat = g:FilterSelect(tp, M.matfilter, 1, 1, c, g, tp, lv, c, flag):GetFirst()

	local val = Card.GetSynchroLevel(fmat, syncard)
	local mg = Group.FromCards(fmat)
	g:RemoveCard(fmat)
	lv = lv - val

	if lv > 1 then
		local temp = g:SelectWithSumEqual(tp, Card.GetSynchroLevel, lv, 1, 99, syncard)
		mg:Merge(temp)
	end

	Duel.SetSynchroMaterial(mg)
end
--
function M.confilter(c)
	return c:GetSequence()>5 or (c:GetSequence()==5 and c:GetOriginalCode()==22090)
end

function M.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(M.confilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
end

function M.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,c) end
	Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_COST+REASON_DISCARD,c)
end

function M.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function M.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetOperation(M.selfdes)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		c:RegisterEffect(e1)
	end
end

function M.selfdes(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
--
function M.desfilter(c)
	return c:IsDestructable()
end

function M.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(M.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end

function M.desop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(M.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) then return end
	local g=Duel.SelectMatchingCard(tp,M.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
