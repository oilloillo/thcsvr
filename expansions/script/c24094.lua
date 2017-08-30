--空想者✿古明地恋
function c24094.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_DECK)
	e1:SetCountLimit(1,24094)
	e1:SetCondition(c24094.spcon)
	e1:SetOperation(c24094.spop)
	c:RegisterEffect(e1)
	--battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--to deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(24094,2))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_REPEAT)
	e4:SetCondition(c24094.condition)
	e4:SetOperation(c24094.activate)
	c:RegisterEffect(e4)
end
function c24094.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil) or
		not Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
end
function c24094.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local opt=2
	local c1=Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil)
	local c2=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
	if not c1 then opt=0 end
	if not c2 then opt=1 end
	if not c1 and not c2 then opt=Duel.SelectOption(tp,aux.Stringid(24094,0),aux.Stringid(24094,1)) end
	if opt==1 then
		e:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
		e:SetTargetRange(POS_FACEUP,1)
	end
	--cannot spsummon
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c24094.splimit)
	Duel.RegisterEffect(e1,tp)
	--cannot summon
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c24094.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c24094.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x14a)
end
function c24094.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c24094.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end
