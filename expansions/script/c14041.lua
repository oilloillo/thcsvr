--梦幻馆 鲜红的门番✿艾丽
function c14041.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14041,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	e1:SetCondition(c14041.ntcon)
	e1:SetOperation(c14041.ntop)
	c:RegisterEffect(e1)
	--double tribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e2:SetValue(c14041.condition)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(14041,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c14041.rmcon)
	e3:SetTarget(c14041.rmtg)
	e3:SetOperation(c14041.rmop)
	c:RegisterEffect(e3)
end
function c14041.ntfilter(c)
	return c:IsSetCard(0x138) and c:IsAbleToDeckAsCost()
end
function c14041.ntcon(e,c)
	if c==nil then return true end
	return c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c14041.ntfilter,c:GetControler(),0x1c,0,1,nil)
end
function c14041.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,c14041.ntfilter,c:GetControler(),0x1c,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c14041.condition(e,c)
	return c:IsSetCard(0x3208)
end
function c14041.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c14041.rmfilter(c)
	return c:IsSetCard(0x138) and c:IsAbleToRemove()
end
function c14041.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14041.rmfilter,tp,0x1c,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c14041.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c14041.rmfilter,tp,0x1c,0,1,1,nil)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e2:SetCode(EVENT_BATTLE_START)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetCondition(c14041.adcon)
		e2:SetOperation(c14041.adop)
		c:RegisterEffect(e2)
	end
end
function c14041.adcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsFaceup() and bit.band(bc:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c14041.adop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		bc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		bc:RegisterEffect(e2)
	end
end
