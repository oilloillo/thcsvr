 
---废狱-力鬼王·星熊勇仪
function c24010.initial_effect(c)
    --sum limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetCondition(c24010.sumlimit)
	c:RegisterEffect(e1)
	--cannot announce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c24010.antarget)
	c:RegisterEffect(e3)
	--summon success
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetOperation(c24010.sumsuc)
	c:RegisterEffect(e4)
end
function c24010.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FIELD) and (c:GetOriginalCode()==(24031) or c:IsSetCard(0x625))
end
function c24010.sumlimit(e)
	return not Duel.IsExistingMatchingCard(c24010.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c24010.antarget(e,c)
	return c~=e:GetHandler()
end
function c24010.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
