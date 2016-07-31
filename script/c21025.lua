 
--蓬莱人的外形✿藤原妹红
function c21025.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(c21025.synfilter),1)
	c:EnableReviveLimit()
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21025,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c21025.damtg)
	e1:SetOperation(c21025.damop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c21025.spcon)
	e2:SetOperation(c21025.spop)
	c:RegisterEffect(e2)
	--attack up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21025,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetCondition(c21025.cd)
	e3:SetOperation(c21025.op)
	c:RegisterEffect(e3)
end
function c21025.synfilter(c)
	return c:IsSetCard(0x208) and c:IsType(TYPE_DUAL)
end
function c21025.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,1000)
end
function c21025.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(tp,1000,REASON_EFFECT)
	Duel.Damage(1-tp,1000,REASON_EFFECT)
end
function c21025.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x208) and c:IsReleasable()
end
function c21025.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFlagEffect(c:GetControler(),21024)==0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c21025.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c21025.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c21025.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Release(g,nil,REASON_COST)
	Duel.RegisterFlagEffect(tp,21024,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c21025.cd(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return tp==ep
end
function c21025.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(300)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	c:RegisterEffect(e1)
end
