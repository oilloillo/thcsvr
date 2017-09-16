--三种神器　电视机
local M = c999207
local Mid = 999207
function M.initial_effect(c)
	--pendulum summon
	local argTable = {1}
	Nef.EnablePendulumAttributeSP(c,2,aux.TRUE,argTable,false)

	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	-- summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(Mid, 0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(M.sptg)
	e1:SetOperation(M.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)

	--synchro custom
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetTarget(M.syntg)
	e3:SetOperation(M.synop)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end

M.tuner_filter=aux.FALSE

function M.synfilter(c, syncard, tuner, f)
	return c:IsFaceup() and c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard, tuner)
		and (f==nil or f(c))
end

function M.lvfilter(c)
	return 0
end

function M.matfilter(c, flag)
	if flag and Duel.GetLocationCountFromEx(tp, tp, c) < 1 then return false end
	return true
end

function M.syntg(e, syncard, f, minc, maxc)
	local c = e:GetHandler()
	local lv = syncard:GetLevel()
	if lv ~= c:GetLevel() then return false end
	local tp = c:GetControler()
	local flag = Duel.GetLocationCountFromEx(tp, tp, c) < 1
	local mg = Duel.GetMatchingGroup(M.synfilter, syncard:GetControler(), LOCATION_MZONE, 0, c, syncard, c, f)
	return mg:IsExists(M.matfilter, 1, c, flag)
end

function M.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
	local c = e:GetHandler()
	local lv = syncard:GetLevel()
	if lv ~= c:GetLevel() then return false end
	local g = Duel.GetMatchingGroup(M.synfilter, syncard:GetControler(), LOCATION_MZONE, 0, c, syncard, c, f)

	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SMATERIAL)
	local flag = Duel.GetLocationCountFromEx(tp, tp, c) < 1
	local fmat = g:FilterSelect(tp, M.matfilter, 1, 1, c, flag):GetFirst()

	local mg = Group.FromCards(fmat)
	g:RemoveCard(fmat)

	if g:GetCount() > 0 and Duel.SelectYesNo(tp, aux.Stringid(Mid, 1)) then
		local temp = g:Select(tp, 1, 99, nil)
		mg:Merge(temp)
	end

	Duel.SetSynchroMaterial(mg)
end
--
function M.spfilter(c,e,tp)
	return c:IsSetCard(0xaa1) and c:IsRace(RACE_MACHINE) and not c:IsFaceup()
end

function M.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(M.spfilter, tp, LOCATION_EXTRA, 0, 2, nil, e, tp) end
end

function M.spop(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local g = Duel.GetMatchingGroup(M.spfilter, tp, LOCATION_EXTRA, 0, nil, e, tp)
	if g:GetCount() < 2 then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
	local sg = g:Select(tp, 2, 2, nil)
	if sg:GetCount() ~= 2 then return end

	Duel.SendtoGrave(sg, REASON_EFFECT)
	Duel.SendtoExtraP(sg, nil, REASON_EFFECT)

	local tc = sg:GetFirst()
	while tc do
		if tc:IsLocation(LOCATION_EXTRA) then
			tc:SetStatus(STATUS_PROC_COMPLETE, true)
		end
		tc = sg:GetNext()
	end
end