 
--梦想天生
function c10020.initial_effect(c)
	--activate proc
	if not c10020.global_check then
		c10020.global_check=true
		local e1=Effect.CreateEffect(c)	
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e1:SetCountLimit(1)
		e1:SetOperation(c10020.operation)
		Duel.RegisterEffect(e1,0)
	end
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c10020.con)
	e2:SetOperation(c10020.op)
	c:RegisterEffect(e2)
end
function c10020.spfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x100)
end
function c10020.operation(e,tp,c)
	local g=Duel.GetMatchingGroup(c10020.spfilter1,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local rc=g:GetFirst()
	while rc do
		rc:RegisterFlagEffect(10020,RESET_EVENT+0x1fe0000,0,1) 	
		rc=g:GetNext()
	end
end
function c10020.filter(c)
	return  c:IsFaceup() and c:IsSetCard(0x100) and c:GetFlagEffect(10020)>3
end
function c10020.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10020.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c10020.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Win(tp,0x22)
end
