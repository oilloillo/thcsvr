--三种神器　电视机
--require "expansions/nef/nef"
function c999207.initial_effect(c)
	--pendulum summon
	local argTable = {1}
	Nef.EnablePendulumAttributeSP(c,1,aux.TRUE,argTable,false)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	-- summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999207,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c999207.sptg)
	e1:SetOperation(c999207.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--synchro custom
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetTarget(c999207.syntg)
	e3:SetOperation(c999207.synop)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
c999207.tuner_filter=aux.FALSE
function c999207.synfilter(c,syncard,tuner,f)
	return c:IsFaceup() and c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard,tuner)
		and (f==nil or f(c))
end
function c999207.lvfilter(c)
	return 0
end
function c999207.syntg(e,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()
	if lv~=c:GetLevel() then return false end
	local g=Duel.GetMatchingGroup(c999207.synfilter,syncard:GetControler(),LOCATION_MZONE,0,c,syncard,c,f)
	return g:GetCount()>0
end
function c999207.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()
	if lv~=c:GetLevel() then return false end
	local g=Duel.GetMatchingGroup(c999207.synfilter,syncard:GetControler(),LOCATION_MZONE,0,c,syncard,c,f)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local sg=g:Select(tp,1,99,nil)
	Duel.SetSynchroMaterial(sg)
end
function c999207.spfilter(c,e,tp)
	return c:IsSetCard(0xaa1) and c:IsRace(RACE_MACHINE) and not c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c999207.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c999207.spfilter,tp,LOCATION_EXTRA,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
end
function c999207.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local c=e:GetHandler()
	local g = Duel.GetMatchingGroup(c999207.spfilter, tp, LOCATION_EXTRA, 0, nil, e, tp)
	if g:GetCount()<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg = g:Select(tp, 2, 2, nil)
	if sg:GetCount()~=2 then return end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	local tc = sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		tc:SetStatus(STATUS_PROC_COMPLETE, true)
		if tc:IsLocation(LOCATION_MZONE) and tc:IsAbleToGrave() then 
			Duel.SendtoGrave(tc, REASON_EFFECT) 
		end
		tc = sg:GetNext()
	end
end