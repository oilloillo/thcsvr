 
--红魔-十六夜咲夜
function c22021.initial_effect(c)
	--summon with no tribute
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22021,0))
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SUMMON_PROC)
	e4:SetCondition(c22021.ntcon)
	e4:SetOperation(c22021.ntop)
	c:RegisterEffect(e4)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c22021.spcon)
	c:RegisterEffect(e1)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e2)
	--skip BP
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCondition(c22021.skipcon)
	e3:SetOperation(c22021.skipop)
	c:RegisterEffect(e3)
end
function c22021.ntfilter(c)
	return c:IsSetCard(0xa999) and c:IsAbleToRemoveAsCost()
end
function c22021.ntcon(e,c)
	if c==nil then return true end
	return c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22021.ntfilter,c:GetControler(),LOCATION_GRAVE,0,1,nil)
end
function c22021.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,c22021.ntfilter,c:GetControler(),LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c22021.spfilter(c)
	return c:IsSetCard(0x810)
end
function c22021.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c22021.spfilter,c:GetControler(),LOCATION_GRAVE,0,1,nil)
end
function c22021.skipcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7e0) and (re:GetHandler():IsCode(22024) or re:GetHandler():IsCode(22120))
end
function c22021.skipop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SKIP_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	if Duel.GetTurnPlayer()~=tp then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(c22021.bpcon)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	end
	Duel.RegisterEffect(e1,tp)
end
function c22021.bpcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
