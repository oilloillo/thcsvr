--冬季的开端✿蕾蒂
function c999508.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsLevelAbove,12),aux.NonTuner(Card.IsSetCard,0x208),1)
	c:EnableReviveLimit()
	--fimbulvinter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999508,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,999508+EFFECT_COUNT_CODE_DUEL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(c999508.con)
	e1:SetTarget(c999508.tg)
	e1:SetOperation(c999508.op)
	c:RegisterEffect(e1)

	if c999508.tag_mode_fix==nil then
		c999508.tag_mode_fix = (Duel.GetLP(0)~=8000)
		c999508.effect_value = (Duel.GetLP(0)~=8000 and 100 or 200)
	end
end

function c999508.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end

function c999508.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end

function c999508.op(e,tp,eg,ep,ev,re,r,rp)
	if c999508.tag_mode_fix then
		Duel.SelectOption(tp,aux.Stringid(999508,1))
	end

	local c=e:GetHandler()
	--attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c999508.val)
	Duel.RegisterEffect(e1,tp)
	local e0=e1:Clone()
	e0:SetCode(EFFECT_UPDATE_DEFENCE)
	Duel.RegisterEffect(e0,tp)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetLabel(1-tp)
	e2:SetTarget(c999508.damtg)
	e2:SetOperation(c999508.damop)
	Duel.RegisterEffect(e2,tp)
end

function c999508.val(e,c)
	return Duel.GetTurnCount()*(0-c999508.effect_value)
end

function c999508.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	return true
end

function c999508.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,999508)

	local lp=Duel.GetLP(e:GetLabel())
	if lp>Duel.GetTurnCount()*c999508.effect_value then 
		lp=lp-Duel.GetTurnCount()*c999508.effect_value
	else 
		lp=0 
	end

	Duel.SetLP(e:GetLabel(),lp)
end