--丰作之地
function c23178.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c23178.lvtg)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(200)
	c:RegisterEffect(e2)
	--Def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_DEFENCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c23178.lvtg)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(200)
	c:RegisterEffect(e3)
	--dice
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(23178,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c23178.target)
	e4:SetOperation(c23178.operation)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e6)
end
function c23178.lvtg(e,c)
	return c:IsRace(RACE_PLANT)
end
function c23178.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(23178)==0 and eg:IsExists(c23178.cfilter,1,nil,tp) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
	e:GetHandler():RegisterFlagEffect(23178,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c23178.cfilter(c,sp)
	return c:IsRace(RACE_PLANT) and c:IsFaceup() and c:GetControler()==sp
end
function c23178.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local dc=Duel.TossDice(tp,1)
	if dc<5 then
		Duel.Draw(tp,1,REASON_EFFECT)
	else
		Duel.Recover(tp,dc*200,REASON_EFFECT)
	end
end
