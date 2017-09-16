--冬天的遗忘之物✿蕾蒂
local M = c999510
local Mid = 999510
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
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,Mid)
	e2:SetCondition(M.spcon)
	e2:SetOperation(M.spop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(Mid,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetTarget(M.destg)
	e3:SetOperation(M.desop)
	c:RegisterEffect(e3)
end

M.tuner_filter=aux.FALSE

function M.lvfilter(c, syncard, addlv)
	return c:GetSynchroLevel(syncard) + addlv
end

function M.synfilter(c, syncard, tuner, f)
	return c:IsFaceup() and c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard, tuner) and (f==nil or f(c))
end

function M.matfilter(c, mg, tp, lv, sync, addlv,flag)
	if flag and Duel.GetLocationCountFromEx(tp, tp, c) < 1 then return false end
	local val = M.lvfilter(c, sync, addlv)
	lv = lv - val
	if lv == 0 then return true end
	if lv > 1 then
		local g = mg:Clone()
		g:RemoveCard(c)
		return g:CheckWithSumEqual(M.lvfilter, lv, 1, 99, sync, addlv)
	end
	return false
end

function M.syntg(e, syncard, f, minc, maxc)
	local c = e:GetHandler()
	local lv = syncard:GetLevel()-c:GetSynchroLevel(syncard)
	if lv <= 0 then return false end
	local tp = c:GetControler()
	local flag = Duel.GetLocationCountFromEx(tp, tp, c) < 1
	local mg = Duel.GetMatchingGroup(M.synfilter, syncard:GetControler(), LOCATION_MZONE, LOCATION_MZONE, c, syncard, c, f)
	local addlv = c:GetLevel()
	return mg:IsExists(M.matfilter, 1, c, mg, tp, lv, syncard, addlv, flag)
end

function M.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
	local c = e:GetHandler()
	local tp = c:GetControler()
	local g = Duel.GetMatchingGroup(M.synfilter, syncard:GetControler(), LOCATION_MZONE, LOCATION_MZONE, c, syncard, c, f)
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SMATERIAL)
	local lv = syncard:GetLevel()-c:GetSynchroLevel(syncard)
	local addlv = c:GetLevel()
	local flag = Duel.GetLocationCountFromEx(tp, tp, c) < 1
	local fmat = g:FilterSelect(tp, M.matfilter, 1, 1, c, g, tp, lv, c, addlv, flag):GetFirst()

	local val = M.lvfilter(fmat, syncard, addlv)
	local mg = Group.FromCards(fmat)
	g:RemoveCard(fmat)
	lv = lv - val

	if lv > 1 then
		local temp = g:SelectWithSumEqual(tp, M.lvfilter, lv, 1, 99, syncard, addlv)
		mg:Merge(temp)
	end

	Duel.SetSynchroMaterial(mg)
end
--
function M.confilter(c)
	return c:GetSequence()==5
end

function M.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and 
		Duel.IsExistingMatchingCard(M.confilter,c:GetControler(),LOCATION_SZONE,0,1,nil)
end

function M.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetOperation(M.selfdes)
	e1:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
end

function M.selfdes(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
--
function M.desfilter(c)
	return c:IsDestructable() and c:IsFaceup() and c:GetLevel()>0 and c:GetLevel() <= Duel.GetTurnCount()
end

function M.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and M.desfilter(chkc) end
	if chk == 0 then return Duel.IsExistingMatchingCard(M.desfilter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
	local g = Duel.SelectTarget(tp, M.desfilter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, g:GetCount(), 0, 0)
end

function M.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc = Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

