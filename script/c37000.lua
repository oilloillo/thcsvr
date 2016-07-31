--决战符『恶作剧』
--require "expansions/nef/uds"
--require "expansions/nef/nef"
function c37000.initial_effect(c)
	if c37000.counter == nil then
		c37000.counter = true
		c37000[0]=10
		c37000[1]=10
	end
	--select
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37001,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_REMOVE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCondition(c37000.condition)
	e1:SetTarget(c37000.target)
	e1:SetOperation(c37000.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(37001,2))
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(37001,3))
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetDescription(aux.Stringid(37001,4))
	c:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetDescription(aux.Stringid(37001,5))
	c:RegisterEffect(e5)
	local e6=e1:Clone()
	e6:SetDescription(aux.Stringid(37001,6))
	c:RegisterEffect(e6)
	local e7=e1:Clone()
	e7:SetDescription(aux.Stringid(37001,7))
	c:RegisterEffect(e7)
	local e8=e1:Clone()
	e8:SetDescription(aux.Stringid(37001,8))
	c:RegisterEffect(e8)
	local e9=e1:Clone()
	e9:SetDescription(aux.Stringid(37001,9))
	c:RegisterEffect(e9)
	local e10=e1:Clone()
	e10:SetDescription(aux.Stringid(37001,10))
	c:RegisterEffect(e10)
end
function c37000.condition(e,tp,eg,ep,ev,re,r,rp)
	local cost = Uds.dataList[e:GetDescription()].cost
	return Duel.GetTurnCount()==1 and Duel.GetCurrentPhase()==PHASE_DRAW and (c37000[tp]>=cost or Duel.GetFlagEffect(tp,37000)<3)
end
function c37000.activate(e,tp,eg,ep,ev,re,r,rp)
	local cost = Uds.dataList[e:GetDescription()].cost
	local code = Uds.dataList[e:GetDescription()].code
	if cost<=c37000[tp] then
		Uds.initCard(code,tp)
		c37000[tp]=c37000[tp]-cost
		if c37000[tp]>0 then
			Duel.RaiseSingleEvent(e:GetHandler(),EVENT_REMOVE,e,REASON_RULE,tp,tp,0)
		end
	else
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(37000,3))
		local token=Duel.CreateToken(tp,37000)
		Duel.Remove(token,POS_FACEDOWN,REASON_RULE)
		Duel.RegisterFlagEffect(tp,37000,RESET_PHASE+PHASE_END,0,1)
		if c37000[tp]>0 then
			Duel.RaiseSingleEvent(e:GetHandler(),EVENT_REMOVE,e,REASON_RULE,tp,tp,0)
		end
	end
end
function c37000.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) end
	Duel.SetChainLimit(c37000.chainlimit)
end
function c37000.chainlimit(e,rp,tp)
	return e:GetHandler():IsCode(37000)
end