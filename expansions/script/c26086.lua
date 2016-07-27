--雨伞『超防水干爽伞妖』
function c26086.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26086.target)
	e1:SetOperation(c26086.activate)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c26086.cona)
	--e2:SetTarget(1)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--mamo
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_RANGE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c26086.mamocon)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c26086.mamotarget)
	e3:SetValue(c26086.mamoval)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetValue(c26086.efilter2)
	c:RegisterEffect(e4)
end
function c26086.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)>0 end
end
function c26086.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()==0 then return end
	Duel.ChangePosition(g,0x1,0x1,0x4,0x4)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTarget(c26086.tg)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(c26086.efilter)
	Duel.RegisterEffect(e1,tp)
end
function c26086.tg(e,c)
	return c:IsSetCard(0x229)
end
function c26086.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer()
end
function c26086.filter1(c)
	return c:IsSetCard(0x229) and c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c26086.filter2(c)
	return c:IsSetCard(0x229) and c:IsType(TYPE_RITUAL) and c:IsFaceup()
end
function c26086.filter3(c)
	return c:IsSetCard(0x229) and c:IsType(TYPE_FUSION) and c:IsFaceup()
end
function c26086.cona(e)
	return Duel.IsExistingMatchingCard(c26086.filter1,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c26086.mamocon(e)
	return Duel.IsExistingMatchingCard(c26086.filter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c26086.mamotarget(e,c)
	return c:IsSetCard(0x306)
end
function c26086.mamoval(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c26086.efilter2(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
