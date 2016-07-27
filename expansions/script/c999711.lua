--鬼神『遗失的高贵之力』
local M = c999711
local Mid = 999711
function M.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetDescription(aux.Stringid(Mid,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_ATTACK,0x11e0)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(M.target)
	e1:SetOperation(M.operation)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetDescription(aux.Stringid(Mid,1))
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(M.target2)
	e2:SetOperation(M.operation2)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetDescription(aux.Stringid(Mid,2))
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(M.cost3)
	e3:SetTarget(M.target3)
	e3:SetOperation(M.operation3)
	e3:SetLabel(0)
	c:RegisterEffect(e3)
end

function M.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xaa5)
end

function M.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and M.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(M.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,M.filter,tp,LOCATION_MZONE,0,1,1,nil)
end

function M.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(tc:GetAttack()*2)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENCE_FINAL)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetValue(tc:GetDefence()*2)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e3:SetCondition(M.rdcon)
		e3:SetOperation(M.rdop)
		tc:RegisterEffect(e3)
		if tc:IsType(TYPE_XYZ) then
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_CHANGE_RANK)
			e4:SetValue(tc:GetRank()*2)
			e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e4)
		else
			local e5=Effect.CreateEffect(e:GetHandler())
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_CHANGE_LEVEL)
			e5:SetValue(tc:GetLevel()*2)
			e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e5)
		end
	end
end

function M.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end

function M.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end

function M.filter1(c,e,tp)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xaa5)
		and Duel.IsExistingMatchingCard(M.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk*2)
end

function M.filter2(c,e,tp,mc,rk,code)
	return c:GetRank()==rk and mc:IsCanBeXyzMaterial(c) and c:IsSetCard(0xaa5)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end

function M.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and M.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(M.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,M.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function M.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,M.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()*2)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end

function M.costfilter(c, e, tp)
	local lv = c:GetLevel()
	return c:IsSetCard(0xaa5) and lv > 0 and lv < 5 and Duel.IsExistingMatchingCard(M.spfilter, tp, LOCATION_EXTRA, 0, 1, nil, lv*2, e, tp)
end

function M.spfilter(c, lv, e, tp)
	return c:GetLevel()==lv and c:IsSetCard(0xaa5) and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_SYNCHRO, tp, false, false)
end

function M.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end

function M.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.CheckReleaseGroup(tp, M.costfilter, 1, nil, e, tp)
	end
	local rg=Duel.SelectReleaseGroup(tp, M.costfilter, 1, 1, nil, e, tp)
	e:SetLabel(rg:GetFirst():GetLevel())
	Duel.Release(rg, REASON_COST)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
end

function M.operation3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp, M.spfilter, tp, LOCATION_EXTRA, 0, 1, 1, nil, lv*2, e, tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g, SUMMON_TYPE_SYNCHRO, tp, tp, false, false, POS_FACEUP)
		local sc=g:GetFirst()
		if sc then
			sc:CompleteProcedure()
		end
	end
end
