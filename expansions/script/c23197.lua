--绝✿对✿许✿早✿苗
function c23197.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c23197.spcon)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23197,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c23197.destg)
	e2:SetOperation(c23197.desop)
	c:RegisterEffect(e2)
end
function c23197.filter(c)
	return c:IsFaceup() and c:IsDisabled()
end
function c23197.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and	Duel.IsExistingMatchingCard(c23197.filter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c23197.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return true end
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function c23197.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	--forbidden
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e1:SetCode(EFFECT_FORBIDDEN)
	e1:SetTarget(c23197.bantg)
	e1:SetLabelObject(tc)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetTarget(c23197.bantg)
	e2:SetLabelObject(tc)
	Duel.RegisterEffect(e2,tp)
end
function c23197.bantg(e,c)
	return c==e:GetLabelObject()
end
