--Lost✿终焉吞噬者
local M = c999101
local Mid = 999101
function M.initial_effect(c)
	c:EnableReviveLimit()
	--Cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--battle
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(Mid, 0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetTarget(M.attg)
	e2:SetOperation(M.atop)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(Mid, 1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(M.tdcon)
	e3:SetTarget(M.tdtg)
	e3:SetOperation(M.tdop)
	c:RegisterEffect(e3)
	--leave field
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(Mid, 2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetTarget(M.sptg)
	e4:SetOperation(M.spop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e6)
end

function M.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end

function M.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0, CATEGORY_TODECK, e:GetHandler(), 1, 0, 0)
end

function M.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c, nil, 2, REASON_EFFECT)
	end
end

function M.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToBattle() end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3300)
	Duel.SetOperationInfo(0, CATEGORY_RECOVER, nil, 0, tp, 3300)
end

function M.atop(e,tp,eg,ep,ev,re,r,rp)
	local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
	Duel.Recover(p, d, REASON_EFFECT)
end

function M.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) end
	Duel.SetOperationInfo(0, CATEGORY_TOKEN, nil, 2, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 2, 0, 0)
end

function M.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp, 59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local c=e:GetHandler()
	if Duel.IsPlayerCanSpecialSummonMonster(tp, 999191, 0x208, 0x4011, 2300, 0, 5, RACE_WARRIOR, ATTRIBUTE_WIND) then
		local token=Duel.CreateToken(tp, 999191)
		Duel.SpecialSummonStep(token, 0, tp, tp, false, false, POS_FACEUP)
		--actlimit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(0, 1)
		e1:SetValue(M.aclimit)
		e1:SetCondition(M.actcon)
		token:RegisterEffect(e1)
		--can not spsummon
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetRange(LOCATION_MZONE)
		e2:SetAbsoluteRange(tp, 1, 0)
		e2:SetTarget(M.splimit)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e2)
	end

	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp, 999192, 0x208, 0x4011, 2300, 1200, 7, RACE_PSYCHO, ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp, 999192)
		Duel.SpecialSummonStep(token, 0, tp, tp, false, false, POS_FACEUP)
		--damage
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_ATTACK_ANNOUNCE)
		e1:SetTarget(M.attg2)
		e1:SetOperation(M.atop2)
		token:RegisterEffect(e1)
		--can not spsummon
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetRange(LOCATION_MZONE)
		e2:SetAbsoluteRange(tp, 1, 0)
		e2:SetTarget(M.splimit)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end

function M.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end

function M.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end

function M.attg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToBattle() end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(700)
	Duel.SetOperationInfo(0, CATEGORY_DAMAGE, nil, 0, 1-tp, 700)
end

function M.atop2(e,tp,eg,ep,ev,re,r,rp)
	local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
	Duel.Damage(p, d, REASON_EFFECT)
end

function M.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end