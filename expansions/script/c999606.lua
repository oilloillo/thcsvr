--宝塔『一番の宝物』
local M = c999606
local Mid = 999606
function M.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(M.con)
	e1:SetTarget(M.tg)
	e1:SetOperation(M.op)
	c:RegisterEffect(e1)
end

function M.confilter(c)
	return c:IsSetCard(0x251e) and c:IsFaceup()
end

function M.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp, LOCATION_MZONE, 0) == 1 
		and Duel.IsExistingMatchingCard(M.confilter, tp, LOCATION_MZONE, 0, 1, nil)
end

function M.filter(c,e,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function M.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then 
		local loc = 0
		if Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 then loc = loc + LOCATION_GRAVE end
		if Duel.GetLocationCountFromEx(tp) > 0 then loc = loc + LOCATION_EXTRA end
		if loc == 0 then return false end
		return Duel.IsExistingMatchingCard(M.filter, tp, loc, 0, 1, nil, e, tp) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, loc)
end

function M.op(e,tp,eg,ep,ev,re,r,rp)	
	local c = e:GetHandler()
	while true do
		local loc = 0
		if Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 then loc = loc + LOCATION_GRAVE end
		if Duel.GetLocationCountFromEx(tp) > 0 then loc = loc + LOCATION_EXTRA end
		if loc == 0 then return end

		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
		local g = Duel.SelectMatchingCard(tp, M.filter, tp, loc, 0, 1, 1, nil, e, tp)
		local tc = g:GetFirst()
		if not tc then return end

		if Duel.SpecialSummonStep(tc, 0, tp, tp, false, false, POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UNRELEASABLE_SUM)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			e3:SetValue(1)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			tc:RegisterEffect(e4)
			local e5=e3:Clone()
			e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			tc:RegisterEffect(e5)
			local e6=Effect.CreateEffect(e:GetHandler())
			e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e6:SetDescription(aux.Stringid(Mid,1))
			e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CLIENT_HINT)
			e6:SetCode(EVENT_PRE_BATTLE_DAMAGE)
			e6:SetOperation(M.rdop)
			e6:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e6,true)
			--
			tc:RegisterFlagEffect(Mid,RESET_EVENT+0x1fe0000,0,1)
		end
	end
	Duel.SpecialSummonComplete()

	local e7=Effect.CreateEffect(e:GetHandler())
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e7:SetCountLimit(1)
	e7:SetOperation(M.tdop)
	Duel.RegisterEffect(e7,tp)
end

function M.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end


function M.tdfilter(c)
	return c:GetFlagEffect(Mid)>0 and c:IsAbleToDeck()
end

function M.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(M.tdfilter, tp, LOCATION_MZONE, 0, nil)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(tp, 1)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(p)
	else
		e:Reset()
	end
end
