 
--风见幽香
function c25004.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c25004.syncon)
	e1:SetOperation(c25004.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c25004.condtion)
	e2:SetValue(4000)
	c:RegisterEffect(e2)
	--multiatk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(25004,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c25004.atkcon)
	e3:SetTarget(c25004.atktg)
	e3:SetOperation(c25004.atkop)
	c:RegisterEffect(e3)
	--summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e4)
	--immune trap
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetValue(c25004.efilter)
	c:RegisterEffect(e6)
	--cannot special summon
	local e7=Effect.CreateEffect(c)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_SPSUMMON_CONDITION)
	e7:SetValue(aux.FALSE)
	c:RegisterEffect(e7)
end
function c25004.matfilter(c,syncard)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c25004.synfilter1(c,lv,g)
	if not c:IsType(TYPE_SYNCHRO) then return false end
	local tlv=c:GetLevel()
	if lv-tlv<=0 then return false end
	local t=false
	if c:IsType(TYPE_TUNER) then t=true end
	g:RemoveCard(c)
	local res=g:IsExists(c25004.synfilter2,1,nil,lv-tlv,g,t)
	g:AddCard(c)
	return res
end
function c25004.synfilter2(c,lv,g,tuner)
	if not c:IsSetCard(0x300) then return false end
	local tlv=c:GetLevel()
	if lv-tlv<=0 then return false end
	if not tuner and not c:IsType(TYPE_TUNER) then return false end
	return g:IsExists(c25004.synfilter3,1,c,lv-tlv)
end
function c25004.synfilter3(c,lv)
	return c:IsNotTuner() and c:GetLevel()==lv
end
function c25004.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c25004.matfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
	if tuner then return c25004.synfilter1(tuner,lv,mg) end
	return mg:IsExists(c25004.synfilter1,1,nil,lv,mg)
end
function c25004.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local mg=Duel.GetMatchingGroup(c25004.matfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
	if tuner then
		local lv1=tuner:GetLevel()
		local t=false
		if tuner:IsType(TYPE_TUNER) then t=true end
		mg:RemoveCard(tuner)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t2=mg:FilterSelect(tp,c25004.synfilter2,1,1,nil,lv-lv1,mg,t)
		local m2=t2:GetFirst()
		g:AddCard(m2)
		local lv2=m2:GetLevel()
		mg:RemoveCard(m2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t3=mg:FilterSelect(tp,c25004.synfilter3,1,1,nil,lv-lv1-lv2)
		g:Merge(t3)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t1=mg:FilterSelect(tp,c25004.synfilter1,1,1,nil,lv,mg)
		local m1=t1:GetFirst()
		g:AddCard(m1)
		local lv1=m1:GetLevel()
		local t=false
		if m1:IsType(TYPE_TUNER) then t=true end
		mg:RemoveCard(m1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t2=mg:FilterSelect(tp,c25004.synfilter2,1,1,nil,lv-lv1,mg,t)
		local m2=t2:GetFirst()
		g:AddCard(m2)
		local lv2=m2:GetLevel()
		mg:RemoveCard(m2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t3=mg:FilterSelect(tp,c25004.synfilter3,1,1,nil,lv-lv1-lv2)
		g:Merge(t3)
	end
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
function c25004.condtion(e)
	local ph=Duel.GetCurrentPhase()
	if not (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a==e:GetHandler() and d and d:IsFaceup() and (d:IsLevelAbove(7) or d:GetRank()>6))
		or (d==e:GetHandler() and (a:IsLevelAbove(7) or a:GetRank()>6))
end
function c25004.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c25004.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK)==0 end
end
function c25004.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(c:GetAttack()/2)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
end
function c25004.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
