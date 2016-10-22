--不朽的弹幕
local M = c999102
local Mid = 999102
function M.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(Mid, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(M.target)
	e1:SetOperation(M.activate)
	c:RegisterEffect(e1)
	--no damage effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(Mid, 1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(aux.damcon1)
	e2:SetTarget(M.tg)
	e2:SetCost(M.cost)
	e2:SetOperation(M.op)
	e2:SetLabel(1)
	e2:SetCountLimit(1, Mid+EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(e2)
	--no damage battle
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(Mid, 1))
	e3:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_HAND)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetCost(M.cost)
	e3:SetCondition(M.con2)
	e3:SetTarget(M.tg)
	e3:SetOperation(M.op)
	e3:SetLabel(2)
	e3:SetCountLimit(1, Mid+EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(e3)
end

function M.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and M.filter(chkc, e, tp) end
	if chk==0 then return Duel.GetLocationCount(tp, LOCATION_MZONE)>0
		and Duel.IsExistingTarget(M.filter, tp, LOCATION_GRAVE, 0, 1, nil, e, tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp, M.filter, tp, LOCATION_GRAVE, 0, 1, 1, nil, e, tp)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, g, 1, 0, 0)
end

function M.filter(c,e,tp)
	return c:IsSetCard(0x137) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function M.activate(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local tc = Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP) > 0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(M.efilter)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e2:SetValue(1)
			tc:RegisterEffect(e2)
		end
	end
end

function M.efilter(e,re)
	return e:GetHandler()~=re:GetOwner()
end

function M.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end

function M.cfilter(c)
	return c:IsSetCard(0x137) and c:IsFaceup()
end

function M.cfilter2(c,e,tp)
	return c:IsSetCard(0x137) and c:IsCanBeSpecialSummoned(e, 0 , tp, false, false, POS_FACEUP)
end

function M.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	return Duel.IsExistingMatchingCard(M.cfilter, tp, LOCATION_ONFIELD+LOCATION_GRAVE, 0, 1, nil)
end

function M.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetBattleDamage(tp)>0
end

function M.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetOperation(M.damop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetOperation(M.damop2)
	e2:SetLabelObject(c)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2, tp)

	if e:GetLabel()==1 then M.damop2(e,tp,eg,ep,ev,re,r,rp) end

	local zc=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local g=Duel.GetMatchingGroup(M.cfilter2, tp, LOCATION_GRAVE, 0, nil, e, tp)
	if zc and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(Mid, 2)) then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
		local sg = g:Select(tp, 1, 1, nil)
		if sg:GetCount()~=1 then return end
		local tc=sg:GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

function M.damop1(e,tp,eg,ep,ev,re,r,rp)
	local dam = Duel.GetBattleDamage(tp)
	local lp = Duel.GetLP(tp)
	if dam > lp then
		Duel.ChangeBattleDamage(tp, lp)
		Duel.Recover(tp, dam-lp, REASON_EFFECT)
	end
end

function M.damop2(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1, 0)
	e1:SetLabel(cid)
	e1:SetValue(M.damval)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1, tp)
end

function M.damval(e,re,val,r,rp,rc)
	local cc=Duel.GetCurrentChain()
	if cc==0 or bit.band(r, REASON_EFFECT)==0 then return val end
	local cid=Duel.GetChainInfo(0, CHAININFO_CHAIN_ID)
	if cid~=e:GetLabel() then return val end
	local tp = e:GetHandlerPlayer()
	local lp = Duel.GetLP(tp)
	if val>lp then
		local e3=Effect.GlobalEffect()
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAIN_SOLVED)
		e3:SetLabel(val-lp)
		e3:SetRange(0xff)
		e3:SetOperation(M.recop)
		e3:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e3, tp)
		return lp
	else
		return val
	end
end

function M.recop(e,tp,eg,ep,ev,re,r,rp)
	local lp = Duel.GetLP(e:GetHandlerPlayer()) 
	local player = e:GetHandlerPlayer()
	Duel.Recover(player, e:GetLabel(), REASON_EFFECT) 
	e:Reset()
end