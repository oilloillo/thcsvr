 
--七曜-土金符「翡翠巨城」
function c22194.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c22194.con)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22194,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(c22194.acttg)
	e2:SetOperation(c22194.actop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_DECK)
	e3:SetCondition(c22194.actcon)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22194,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c22194.cost)
	e4:SetOperation(c22194.operation)
	c:RegisterEffect(e4)
end
function c22194.con(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():GetFlagEffect(22194)==1
end
function c22194.actfilter1(c)
	return c:IsSetCard(0x182) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsFaceup()
end
function c22194.actfilter2(c)
	return c:IsSetCard(0x181) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsFaceup()
end
function c22194.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22194.actfilter1,tp,LOCATION_SZONE,0,1,nil) and 
		Duel.IsExistingMatchingCard(c22194.actfilter2,tp,LOCATION_SZONE,0,1,nil) end
	e:GetHandler():RegisterFlagEffect(22194,RESET_EVENT+0x1fe0000,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c22194.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c22194.actfilter1,tp,LOCATION_SZONE,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c22194.actfilter2,tp,LOCATION_SZONE,0,1,1,nil)
	g1:Merge(g2)
		if Duel.SendtoGrave(g1,REASON_MATERIAL)~=0 then
			if not e:GetHandler():GetActivateEffect():IsActivatable(tp) then return end
			Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	Duel.RaiseEvent(e:GetHandler(),EVENT_CHAIN_SOLVED,e:GetHandler():GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
end
function c22194.dactfilter(c)
	return c:IsFaceup() and c:IsCode(22017)
end
function c22194.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22194.dactfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22194.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
function c22194.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetTargetRange(0,1)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_MSET)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	e2:SetTargetRange(0,1)
	e2:SetTarget(aux.TRUE)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SSET)
	Duel.RegisterEffect(e3,tp)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_TURN_SET)
	Duel.RegisterEffect(e4,tp)
	local e5=e2:Clone()
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetTarget(c22194.sumlimit)
	Duel.RegisterEffect(e5,tp)
end
function c22194.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumpos,POS_FACEDOWN)>0
end
