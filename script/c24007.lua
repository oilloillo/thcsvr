 
---废狱-地壳下的嫉妒心·水桥帕露西
function c24007.initial_effect(c)
    --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c24007.spcon)
	c:RegisterEffect(e2)
	--tuner
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24007,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c24007.target)
	e1:SetOperation(c24007.operation)
	c:RegisterEffect(e1)
end
function c24007.filter(c)
	return c:IsFaceup() and not c:IsType(TYPE_TUNER) and not c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x625)
end
function c24007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
end
function c24007.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c24007.filter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c24007.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and	Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
